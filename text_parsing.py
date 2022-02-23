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

def find_likely_email(text, chunk_size, flag_words = ["data","dataset","access","obtain","get","copy"]):
    """ Takes a string of text, chunk size, and words to look for, returns a list of chunks of text around email addresses that
    might be saying to contact this address for data, and the email addresses. """
    pattern = re.compile(r'\b\S+@\S+\b')
    likely_list = []
    for match in pattern.finditer(text):
        location = match.start()
        if location < chunk_size:
            start_chunk = 0
        else:
            start_chunk = location - chunk_size
        if len(text) - location < chunk_size:
            end_chunk = len(text)
        else:
            end_chunk = location + chunk_size
        chunk = text[start_chunk:end_chunk]
        chunk_words = set(pad_punctuation(chunk))
        flag_words = set(flag_words)
        if len(list(chunk_words.intersection(flag_words))) > 0:
            likely_list += [[match.group(), chunk]]
        else:
            pass
    return likely_list

print(find_likely_email("corresponding author: data jz@fake.edu data whatever contact for data it is jzimmer1@uvm.edu. and also it is jwzimmer1990@gmail.com",15))