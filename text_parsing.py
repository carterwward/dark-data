# coding=utf-8
import re

def pad_punctuation(text):
    """ Takes a string of text, returns a vector of words including punctuation. """
    # I took "——", "—" out of the list because I got an error about declaring encoding
    punc_list = ["!","&",".","?",",","-","(",")","~",'"']
    words = text.lower()
    for punc in punc_list:
        words = re.sub(re.escape(punc)," "+punc+" ",words)
    words = words.split()
    return words

link_pattern = re.compile(r'(?<=\s|\/|:)\b[https:\/\/]*[http:\/\/]*\w+\.\S+\b')
email_pattern = re.compile(r'\b\S+@\S+\b')
link_flag_words = ["data","dataset","access","obtain","get","copy","go to","repo","repository","github","link","retrieved","from","public","publicly","available"]

email_flag_words = ["data","dataset","access","obtain","get","copy"]

def find_likely(text, chunk_size, pattern, flag_words):
    """ Takes a string of text, chunk size, regex pattern, and words to look for, returns a list of chunks of text
    around the likely object that might be what we're looking for,
    and the likely object itself. """
    likely_list = []
    for match in pattern.finditer(text):
        location = match.start()
        the_match = match.group()
        if (location + len(the_match)) < chunk_size:
            start_chunk = 0
        else:
            start_chunk = location - chunk_size
        if (len(text) - (location + len(the_match))) < chunk_size:
            end_chunk = len(text)
        else:
            end_chunk = location + len(the_match) + chunk_size
        chunk = text[start_chunk:end_chunk]
        chunk_words = set(pad_punctuation(chunk))
        flag_words = set(flag_words)
        if len(list(chunk_words.intersection(flag_words))) > 0:
            likely_list += [[the_match, chunk]]
        else:
            pass
    return likely_list

print(find_likely("corresponding author: data jz@fake.edu data whatever go to www.our-stuff.com and our repo is https://this.net.why",
                        20, link_pattern, link_flag_words))