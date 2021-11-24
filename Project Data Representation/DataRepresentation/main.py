from files import *


contents = read_file("input.txt", UTF_16)
write_file("input.txt", contents, UTF_16)
html_string = ""
for i in contents:
    codepoint = ord(i)
    html_string = html_string + '&#{:d}'.format(codepoint)
write_html_file("input.txt", html_string)