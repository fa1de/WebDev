from flask import Flask

app = Flask(__name__)

topics = [{"id" : 1, "title" : "html", "body" : "Html is~"},
         {"id" : 2, "title" : "CSS", "body" : "CSS is~"},
         {"id" : 3, "title" : "JavaScript", "body" : "JS is~"}
        ]

def templates(contents, content):
    return f'''  
    <doctype html> 
    <html>
        <body>
            <h1><a href="/">WEB</a></h1>
            <ol>
                {contents}
            </ol>
            {content}
        </body>
    </html>
    '''

def getcontents():
    litags = ""
    for topic in topics:
        litags = litags + f'<li><a href="/read/{topic["id"]}/">{topic["title"]}</a></li>'
    return litags

@app.route('/') 
def index():    
    
    return templates(getcontents(), "<h2>Welcome to web</h2>")

@app.route('/create/')
def create():
    return 'Create'

@app.route('/read/<int:id>/')
def read(id):
    title = ""
    body = ""
    for topic in topics:
        if id == topic["id"]:
            title = topic["title"]
            body = topic["body"]
            break
    return templates(getcontents(), f'<h2>{title}</h2>{body}')


app.run(debug=True)