from flask import Flask

app = Flask(__name__)

topics = [{"id" : 1, "title" : "html", "body" : "Html is~"},
         {"id" : 2, "title" : "CSS", "body" : "CSS is~"},
         {"id" : 3, "title" : "JavaScript", "body" : "JS is~"}
        ] # <li>로 순서가 있는 것은 리스트에 넣고, a href=~부분의 데이터는 딕셔너리에 저장

#def template(contents, content):                   # 겹치는 내용 함수에 저장
#    return '''  
#    <doctype html> 
#    <html>
#        <body>
#            <h1><a href="/">Main Page</a></h1>
#            <ol>
#                {contents}
#            </ol>
#            {content}
#        </body>
#    </html>
#    '''

#def getcontents():
#   litags =""
#   for topic in topics:
#       litags = litags + f'<li><a href="/read/{topic["id"]}/">{topic["title"]}</a></li>'
#   return litags     

@app.route('/') # route 데코레이터
def index():    # ex)random.random() : 모듈.함수(.모듈이 갖고있는 함수) return은 문자열을 응답
    litags =""
    for topic in topics:
        litags = litags + "<li>"+topic["title"]+"</li>"  #f string : litags = litags + f'<li><a href="/read/{topic["id"]}/">{topic["title"]}</a></li>'
    return '''  
    <doctype html> 
    <html>
        <body>
            <h1><a href="/">Main Page</a></h1>
            <ol>
            <li><a href="/read/1/>Html</a></li>
            <li><a href="/read/2/>CSS</a></li>              
            <li><a href="/read/3/>JavaScript</a></li>
            </ol>
            Hello, Web
        </body>
    </html>
    '''  # '''는 여러줄의 문자열 정의를 위해 사용 : 트리플 쿼트
         #<ol></ol> 안의 내용을 # litags로 치환 가능. '''앞에 f string 쓰면 {litags} / 포매팅도 가능
         
    #겹치는 내용은 return template(getcontents{}, '<h2>Welcome</h2>Hello, Web) 이렇게 변경 가능.
    
@app.route('/create/')
def create():
    return 'Create'

@app.route('/read/1/')         
def read1():
    return 'This is read 1'

@app.route('/read/2/')
def read1(): 
    return 'This is read 2'

@app.route('/read/3/')            #read/?/ 숫자에 따라 하나하나 말고 @app.route('/read/<id>/')
def read1():                      #                                 def read(id):
    return 'This is read 3'       #                                 return 'read'+ id   로 바꿀 수 있음.

#app.route('/read/<int:id>/')  #id를 int로 지정
#def read(id):
#    litags =""
#    for topic in topics:
#        litags = litags + f'<li><a href="/read/{topic["id"]}/">{topic["title"]}</a></li>'
#    for topic in topics:
#        if id == topic["id"]:
#            title = topic["id"]
#            body == topic["body"]
#            break
#    return f'''  
#    <doctype html> 
#    <html>
#        <body>
#            <h1><a href="/">WEB</a></h1>
#            <ol>
#               {litags}
#            </ol>
#            <h2>{title}</h2>
#            {body}                            #title과 body를 불러옴
#        </body>
#    </html>
#   '''    

#@app.route('/user/<username>')   #username에 따른 페이지
#def 함수명(username):             #<username> -> 여기 받는 파라미터 값이 username으로 들어감
#    return 'hi'+username  


app.run(debug=True)  #flask는 보통 5000번사용. 겹칠 시 run(port=5001)등 이렇게 다른포트 사용가능 
# 코드를 고치고 새로고침을 하면 반영이 안되서 매번 껏다 켜야함. app.run(debug=True)를 넣으면 자동으로 수정하면 껏다켜지게 할 수 있음. 수정모드느낌
