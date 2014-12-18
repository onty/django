from django.http import HttpResponse
from django.template import RequestContext
from django.shortcuts import render_to_response
from rango.models import Category
from rango.models import Page

def index(request):
    context = RequestContext(request)
    category_list = Category.objects.order_by('-likes')[:5]
    page_list = Page.objects.order_by('-views')[:5]
    context_dict = {'categories': category_list, 
            'pages': page_list}
    for category in category_list:
        # category.url = category.name.replace(' ', '_')
        category.url = UrlHelper('encode',category.name)

    return render_to_response('rango/index.html', context_dict, context)


def about(request):
    return HttpResponse("About page, click <a href='/rango/'>here</a> to return")

def UrlHelper(function, input):
    print function
    if function.lower() == 'encode':
        print input
        return input.replace(' ','_')
    elif function.lower() == 'decode':
        print input
        return input.replace('_',' ')


def category(request, category_name_url):
    context = RequestContext(request)
    #category_name = category_name_url.replace('_',' ')
    category_name = UrlHelper('decode',category_name_url)
    context_dict = {'category_name': category_name}

    try:
        category = Category.objects.get(name=category_name)
        pages = Page.objects.filter(category=category)
        context_dict['pages'] = pages
        context_dict['category'] = category
    except category.DoesNotExist:
        pass

    return render_to_response('rango/category.html', context_dict, context)

