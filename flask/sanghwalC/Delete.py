from flask import Flask, request, redirect

app = Flask(__name__)

topics = [{"id" : 1, "title" : "html", "body" : "Html is~"},
         {"id" : 2, "title" : "CSS", "body" : "CSS is~"},
         {"id" : 3, "title" : "JavaScript", "body" : "JS is~"}
        ]
nextId = 4

def templates(contents, content, id=None):
    contextUI = ""
    if(id != None):
        contextUI = f'''
            <li><a href="/update/{id}/">update</a></li>
            <li><form action="/delete/{id}/" method="POST"><input type="submit" value="delete"></form></li>
        '''
    return f'''  
    <doctype html> 
    <html>
        <body>
            <h1><a href="/">WEB</a></h1>
            <ol>
                {contents}
            </ol>
            {content}
            <ul>
                <li><a href="/create/">Create</a></li>
                {contextUI}
            </ul>    
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

@app.route('/read/<int:id>/')
def read(id):
    title = ""
    body = ""
    for topic in topics:
        if id == topic["id"]:
            title = topic["title"]
            body = topic["body"]
            break
    return templates(getcontents(), f'<h2>{title}</h2>{body}', id)

@app.route('/create/', methods=['GET','POST'])   
def create():
    if (request.method == 'GET'):
        content = '''
            <form action="/create/" method="POST">
                <p><input type="text" name="title" placeholder="title"><p> 
                <p><textarea name="body" placeholder="body"></textarea><p>
                <p><input type="submit" value="create"></p>
            </form>
        ''' 
        return templates(getcontents(), content)
    
    elif (request.method == 'POST'):
        global nextId   
        title = request.form['title']
        body = request.form['body']
        newtopic = {"id" : nextId, "title": title, "body": body}
        topics.append(newtopic)
        url = '/read/'+str(nextId)+'/'
        nextId = nextId + 1
        return redirect(url)
    

@app.route('/update/<int:id>/', methods=['GET','POST'])   
def update(id):
    if (request.method == 'GET'):
        title = ""
        body = ""
        for topic in topics:
            if id == topic["id"]:
                title = topic["title"]
                body = topic["body"]
                break
        content = f'''
            <form action="/update/{id}/" method="POST">
                <p><input type="text" name="title" placeholder="title" value="{title}"><p> 
                <p><textarea name="body" placeholder="body" >{body}</textarea><p>
                <p><input type="submit" value="update"></p>
            </form>
        ''' 
        return templates(getcontents(), content)
    
    elif (request.method == 'POST'):
        global nextId   
        title = request.form['title']
        body = request.form['body']
        for topic in topics:
            if id == topic['id']:
                topic['title'] = title
                topic['body'] = body
                break
        url = '/read/'+str(id)+'/'
        return redirect(url) 
    
@app.route('/delete/<int:id>/', methods=['POST'])   # GET방식을 할 경우 페이지경로만 입력했을 때 삭제가 될 수 있기에 POST방식만 사용
def delete(id):
    for topic in topics:
        if id == topic['id']:
            topics.remove(topic)    # 파라미터로 삭제하고 싶은 값을 전달하면 변수에서 삭제해줌
            break
    return redirect('/')   # 삭제 후 메인 페이지로 이동

app.run(debug=True)