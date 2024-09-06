from flask import Flask

app = Flask(__name__)


@app.route('/') # route 데코레이터
def index():    # ex)random.random() : 모듈.함수(.모듈이 갖고있는 함수) return은 문자열을 응답
    return '''  
    <doctype html>
    <html>
        <body>
            <h1><a href="/">Main</a></h1>
        </body>
    </html>
    '''  # '''는 여러줄의 문자열 정의를 위해 사용 : 트리플 쿼트
@app.route('/create/')
def create():
    return 'Create'

#@app.route('/user/<username>')    username에 따른 페이지
#def 함수명(username):
#    return 'hi'+username  


app.run(debug=True)  #flask는 보통 5000번사용. 겹칠 시 run(port=5001)등 이렇게 다른포트 사용가능 
# 코드를 고치고 새로고침을 하면 반영이 안되서 매번 껏다 켜야함. app.run(debug=True)를 넣으면 자동으로 수정하면 껏다켜지게 할 수 있음. 수정모드느낌
