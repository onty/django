import hashlib, zlib, urllib
import cPickle as pickle

my_secret = "bismillah"

def encode(data):
    """Turn `data` into a hash and an encoded string, suitable for use with `decode_data`."""
    text = zlib.compress(pickle.dumps(data, 0)).encode('base64').replace('\n', '')
    m = hashlib.md5(my_secret + text).hexdigest()[:12]
    return m, text

def decode(hash, enc):
    """The inverse of `encode_data`."""
    text = urllib.unquote(enc)
    m = hashlib.md5(my_secret + text).hexdigest()[:12]
    if m != hash:
        raise Exception("Bad hash!")
    data = pickle.loads(zlib.decompress(text.decode('base64')))
    return data

if __name__ == "__main__":
    str1 = raw_input("Your string 1 ? ")
    str2 = raw_input("Your string 2 ? ")
    hash, enc = encode([str1, str2])
    print hash, enc
    print decode(hash, enc)