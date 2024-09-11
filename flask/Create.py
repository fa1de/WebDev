from flask import Flask, request, redirect

app = Flask(__name__)

nextId = 4
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
            <ul>
                <li><a href="/create/">Create</a></li>
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
    return templates(getcontents(), f'<h2>{title}</h2>{body}')

@app.route('/create/', methods=['GET','POST'])   # GET 방식만 받는 라우트, methods 지정
def create():
    if (request.method == 'GET'):
        content = '''
            <form action="/create/" method="POST">
                <p><input type="text" name="title" placeholder="title"><p> 
                <p><textarea name="body" placeholder="body"></textarea><p>
                <p><input type="submit" value="create"></p>
            </form>
        ''' # <input type="text" placeholder="title"> : 입력공간, 무엇을 입력해야 하는지 표시,<p>: 단락구분
        # <textarea placeholder="body"></textarea> : body는 여러줄을 써야하기에 input type보다 textarea를 씀.
        # <input type="submit" value="create"> : 입력데이터 전송버튼, value를 사용해 버튼 이름변경
        # form action : 사용자가 입력한 정보를 서버로 전송하는데 action은 서버의 어떤 경로로 전송 할 것인가, name은 각각의 값들을 어떤 이름으로 전송 할 것인가. 
        # url을 통해 서버로 데이터를 전송하는 방식 : GET방식, 값을 변경할 때는 POST방식 사용, method라는 속성의 기본값은 GET 다른방식으로 사용하고싶으면 변경
        # POST 전송은 url로 전송되지않음(url안에 데이터가 포함된 방식 : 특정 데이터를 읽어올 때 사용, 사용자가 데이터를 변경 할 때는 POST방식 사용)
        return templates(getcontents(), content)
    
    elif (request.method == 'POST'):
        global nextId     # 전역변수 설정
        title = request.form['title']
        body = request.form['body']
        newtopic = {"id" : nextId, "title": title, "body": body}
        topics.append(newtopic)
        url = '/read/'+str(nextId)+'/' #'/read/'+nextId로 하면 문자열+숫자가 되기에 str을 씌움
        nextId = nextId + 1
        return redirect(url) # redirect를 임포트해서 매핑된 url로 리다이렉트


app.run(debug=True)