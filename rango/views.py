from django.contrib.auth.decorators import login_required
from django.contrib.auth import authenticate, login, logout
from django.http import HttpResponseRedirect, HttpResponse
from django.http import HttpResponse
from django.template import RequestContext
from django.shortcuts import render_to_response
from rango.models import Category
from rango.models import Page
from rango.models import UserProfile
from rango.forms import CategoryForm
from rango.forms import PageForm
from rango.forms import UserForm
from rango.forms import UserProfileForm
from datetime import datetime
from rango.bing_search import run_query
from django.contrib.auth.models import User
from django.shortcuts import redirect


def index(request):
    context = RequestContext(request)
    category_list = Category.objects.order_by('-name')
    page_list = Page.objects.order_by('-views')[:5]
    context_dict = {'cat_list': category_list, 
            'pages': page_list}
    for category in category_list:
        # category.url = category.name.replace(' ', '_')
        category.url = UrlHelper('encode',category.name)

    #### NEW CODE ####
    # Obtain our Response object early so we can add cookie information.
    response = render_to_response('rango/index.html', context_dict, context)

    # Get the number of visits to the site.
    # We use the COOKIES.get() function to obtain the visits cookie.
    # If the cookie exists, the value returned is casted to an integer.
    # If the cookie doesn't exist, we default to zero and cast that.
    visits = int(request.COOKIES.get('visits', '0'))

    #### NEW CODE ####
    if request.session.get('last_visit'):
        # The session has a value for the last visit
        last_visit_time = request.session.get('last_visit')
        visits = request.session.get('visits', 0)

        if (datetime.now() - datetime.strptime(last_visit_time[:-7], "%Y-%m-%d %H:%M:%S")).days > 0:
            request.session['visits'] = visits + 1
            request.session['last_visit'] = str(datetime.now())
    else:
        # The get returns None, and the session does not have a value for the last visit.
        request.session['last_visit'] = str(datetime.now())
        request.session['visits'] = 1
    #### END NEW CODE ####

    # Render and return the rendered response back to the user.
    return render_to_response('rango/index.html', context_dict, context)
    

def about(request):
    context = RequestContext(request)
    if request.session.get('visits'):
        count = request.session.get('visits')
    else:
        count = 0

# remember to include the visit data
    return render_to_response('rango/about.html', {'visit_count': count, 'cat_list' : get_category_list}, context)
    
def UrlHelper(function, input):
    
    if function.lower() == 'encode':
        return input.replace(' ','_')
    elif function.lower() == 'decode':
        return input.replace('_',' ')


def category_list(request):
    context = RequestContext(request)
    cat_list = Category.objects.order_by('-likes')
    for category in cat_list:
            # category.url = category.name.replace(' ', '_')
            category.url = UrlHelper('encode',category.name)

    return render_to_response('rango/category_list.html', {'cat_list':cat_list}, context)

def suggest_category(request):
    context = RequestContext(request)
    cat_list = []
    starts_with = ''

    if request.method == 'GET':
        starts_with = request.GET['suggestion']

    cat_list = get_category_list(8,starts_with)

    return render_to_response('rango/category_list.html', {'cat_list' : cat_list}, context)

def get_category_list(max_result=0,starts_with=''):
    cat_list = []

    if starts_with:
        cat_list = Category.objects.filter(name__istartswith=starts_with)
        
    else:
        cat_list = Category.objects.all().order_by('-name')

    if max_result > 0:
        if len(cat_list) > max_result:
            cat_list = cat_list[:max_result]

    for cat in cat_list:
        cat.url = UrlHelper('encode', cat.name)

    return cat_list

@login_required
def auto_add_page(request):    
    context = RequestContext(request)
    strHtml = ''
    cat_id = None
    title = None
    url = None

    if request.method == 'GET':
        cat_id = request.GET['category_id']
        url = request.GET['url']
        title = request.GET['title']

        if cat_id:
            category = Category.objects.get(id=int(cat_id))
            Page.objects.get_or_create(category=category, title=title, url=url)
        
        strHtml = "<ul>"
        for page in Page.objects.filter(category=category):
                strHtml = strHtml + "<li><a href=\"/rango/goto/?page_id=" + str(page.id) + "\">" + page.title + " - "+ str(page.views) + "</a></li>"
            
        strHtml = strHtml + "</ul>"

        
    return HttpResponse(strHtml)

@login_required
def like_category(request):
    context = RequestContext(request)
    cat_id = None
    if request.method == 'GET':
        cat_id = request.GET['category_id']

    likes = 0
    if cat_id:
        category = Category.objects.get(id=int(cat_id))
        if category:
            likes = category.likes+1
            category.likes = likes
            category.save()

    return HttpResponse(likes)


@login_required
def category(request, category_name_url):
    context = RequestContext(request)
    #category_name = category_name_url.replace('_',' ')
    category_name = UrlHelper('decode',category_name_url)
    context_dict = {'category_name': category_name}

    try:
        category = Category.objects.get(name__iexact=category_name)
        pages = Page.objects.filter(category=category).order_by('-views')
        context_dict['pages'] = pages
        context_dict['category'] = category
        context_dict['category_name_url'] = category_name_url
        context_dict['cat_list'] = get_category_list
    except  Category.DoesNotExist:
        return render_to_response('rango/category_not_found.html', context_dict, context)

    if request.method == 'POST':
        query = request.POST['query'].strip()

        if query:
            # Run our Bing function to get the results list!
            result_list = run_query(query)
            context_dict['result_list'] = result_list

    return render_to_response('rango/category.html', context_dict, context)

@login_required
def add_category(request):
    # Get the context from the request.
    context = RequestContext(request)

    # A HTTP POST?
    if request.method == 'POST':
        form = CategoryForm(request.POST)

        # Have we been provided with a valid form?
        if form.is_valid():
            # Save the new category to the database.
            form.save(commit=True)

            # Now call the index() view.
            # The user will be shown the homepage.
            return index(request)
        else:
            # The supplied form contained errors - just print them to the terminal.
            print form.errors
    else:
        # If the request was not a POST, display the form to enter details.
        form = CategoryForm()

    # Bad form (or form details), no form supplied...
    # Render the form with error messages (if any).
    return render_to_response('rango/add_category.html', {'form': form, 'cat_list': get_category_list}, context)

@login_required
def add_page(request, category_name_url):
    context = RequestContext(request)

    category_name = UrlHelper('decode',category_name_url)
    if request.method == 'POST':
        form = PageForm(request.POST)

        if form.is_valid():
            # This time we cannot commit straight away.
            # Not all fields are automatically populated!
            page = form.save(commit=False)

            # Retrieve the associated Category object so we can add it.
            # Wrap the code in a try block - check if the category actually exists!
            try:
                cat = Category.objects.get(name=category_name)
                page.category = cat
            except Category.DoesNotExist:
                # If we get here, the category does not exist.
                # Go back and render the add category form as a way of saying the category does not exist.
                return render_to_response('rango/add_category.html', {}, context)

            # Also, create a default value for the number of views.
            page.views = 0

            # With this, we can then save our new model instance.
            page.save()

            # Now that the page is saved, display the category instead.
            return category(request, category_name_url)
        else:
            print form.errors
    else:
        form = PageForm()

    return render_to_response( 'rango/add_page.html',
            {'category_name_url': category_name_url,
             'category_name': category_name, 'form': form, 
             'cat_list' : get_category_list},
             context)

def track_url(request):
    if request.method == 'GET':
        if 'page_id' in request.GET:
            try: 
                page_id = request.GET['page_id']
                page = Page.objects.get(id=page_id)
                url = page.url
                page.views = page.views + 1
                page.save()
            except:
                pass

    return redirect(url)

def register(request):
    # Like before, get the request's context.
    context = RequestContext(request)
    # A boolean value for telling the template whether the registration was successful.
    # Set to False initially. Code changes value to True when registration succeeds.
    registered = False

    # If it's a HTTP POST, we're interested in processing form data.
    if request.method == 'POST':
        # Attempt to grab information from the raw form information.
        # Note that we make use of both UserForm and UserProfileForm.
        user_form = UserForm(data=request.POST)
        profile_form = UserProfileForm(data=request.POST)

        # If the two forms are valid...
        if user_form.is_valid() and profile_form.is_valid():
            # Save the user's form data to the database.
            user = user_form.save()

            # Now we hash the password with the set_password method.
            # Once hashed, we can update the user object.
            user.set_password(user.password)
            user.save()

            # Now sort out the UserProfile instance.
            # Since we need to set the user attribute ourselves, we set commit=False.
            # This delays saving the model until we're ready to avoid integrity problems.
            profile = profile_form.save(commit=False)
            profile.user = user

            # Did the user provide a profile picture?
            # If so, we need to get it from the input form and put it in the UserProfile model.
            if 'picture' in request.FILES:
                profile.picture = request.FILES['picture']

            # Now we save the UserProfile model instance.
            profile.save()

            # Update our variable to tell the template registration was successful.
            registered = True

        # Invalid form or forms - mistakes or something else?
        # Print problems to the terminal.
        # They'll also be shown to the user.
        else:
            print user_form.errors, profile_form.errors

    # Not a HTTP POST, so we render our form using two ModelForm instances.
    # These forms will be blank, ready for user input.
    else:
        user_form = UserForm()
        profile_form = UserProfileForm()

    # Render the template depending on the context.
    return render_to_response(
            'rango/register.html',
            {'cat_list' : get_category_list,'user_form': user_form, 'profile_form': profile_form, 'registered': registered},
            context)

def user_login(request):
    context = RequestContext(request)
    dict_list = {'cat_list' : get_category_list}

    if request.method == 'POST':
        username = request.POST['username']
        password = request.POST['password']
        

        user = authenticate(username=username, password=password)
        print dir(user)

        if user:
            if user.is_active:
                login(request, user)
                return HttpResponseRedirect('/rango/')
            else:
                dict_list['disabled_account'] = 1
        else:
            dict_list['bad_details'] = 1
            print "Invalid login details {0}, {1}".format(username, password)

    
    return render_to_response('rango/login.html',dict_list,context)

@login_required
def restricted(request):
    return HttpResponse("Since you are logged in , you can see the text")

@login_required
def user_logout(request):
    logout(request)

    return HttpResponseRedirect('/rango/')

@login_required
def profile(request):
    context = RequestContext(request)
    u = User.objects.get(username=request.user)

    try:
        up = UserProfile.objects.get(user=u)
        
    except:
        up = None

    return render_to_response('rango/profile.html', 
        {'cat_list' : get_category_list, 'user': u, 'userProfile': up}, 
        context)

def forgot(request):
    context = RequestContext(request)
    email = None 
    if request.method == 'POST':
        email = request.POST['email']
        reset_password(email)

    return render_to_response('rango/forgot.html', 
        {'cat_list' : get_category_list, 'email' : email}, 
        context)

def reset_password(email):
    pass

def search(request):
    context = RequestContext(request)
    result_list = []

    if request.method == 'POST':
        query = request.POST['query'].strip()

        if query:
            # Run our Bing function to get the results list!
            result_list = run_query(query)

    return render_to_response('rango/search.html', {'result_list': result_list}, context)