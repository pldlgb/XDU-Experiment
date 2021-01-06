# coding=utf-8
# coding:= utf-8
from math import *
import matplotlib.pyplot as plt

# 记号类别
Type = ['ORIGIN', 'SCALE', 'ROT', 'IS', 'TO', 'STEP', 'DRAW',
        'FOR', 'FROM', 'T', 'SEMICO', 'L_BRACKET', 'R_BRACKET',
        'COMMA', 'PLUS', 'MINUS', 'MUL', 'DIV', 'POWER', 'FUNC',
        'CONST_ID', 'NONTOKEN', 'ERRTOKEN', 'WHITE_SPACE']
# 记号表
tokenTabType = ['CONST_ID', 'CONST_ID', 'T', 'FUNC', 'FUNC', 'FUNC',
                'FUNC', 'FUNC', 'FUNC', 'ORIGIN', 'SCALE', 'ROT', 'IS',
                'FOR', 'FROM', 'TO', 'STEP', 'DRAW']
# 对应属性，原始输入的字符串
tokenTabInput = ['PI', 'E', 'T', 'SIN', 'COS', 'TAN', 'LN', 'EXP', 'SQRT',
                 'ORIGIN', 'SCALE', 'ROT', 'IS', 'FOR', 'FROM', 'TO',
                 'STEP', 'DRAW']
# 对应的属性值，数值
Value = [3.1415926, 2.71828, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
         0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
# 属性，若记号是函数则存函数地址
Address = ['null', 'null', 'null', 'sin', 'cos', 'tan', 'log', 'exp',
           'sqrt', 'null', 'null', 'null', 'null', 'null', 'null',
           'null', 'null', 'null']


# Scanner类
class Scanner:
    # 类初始化
    def __init__(self):
        self.Token = 'null'
        self.Type = 'null'
        self.Value = 0.0
        self.Address = 'null'

    # 获得记号

    def getToken(self, stream):
        if len(stream) == 0:
            exit(0)
        i = 0  # 定位stream[i]位置
        temp = []
        ch = stream[0]
        if ch.isalpha():
            s = 1
            while (1):
                temp.append(ch)  # 将字母添加到temp
                i = i + 1  # 字长计数加1
                if i == len(stream):
                    break
                ch = stream[i]
                if not ch.isalpha():
                    i = i - 1  # 最后stream[i]非字符i-1
                    break
            if ''.join(temp) in tokenTabInput:  # 将temp里的字符连接成字符串并判断是否在tokenTabInput
                self.Token = ''.join(temp)  # 赋值
                self.location = tokenTabInput.index(''.join(temp))  # 获得在input表的下标
                self.Type = tokenTabType[self.location]  # 记号类型
                self.Value = Value[self.location]  # 获得属性——数值
                self.Address = Address[self.location]  # 获得函数地址
                return i + 1
            else:
                print("Token error!")
                exit(-1)
        elif ch.isdigit():  # 识别常数
            s = 2
            while (1):
                temp.append(ch)
                i = i + 1
                if i == len(stream):
                    break
                ch = stream[i]
                if not ch.isdigit() and ch != '.':
                    i = i - 1
                    break
                if ch == '.' and s == 2:  # 识别到11.1之类的并将状态置为3
                    s = 3
                    continue
                if ch == '.' and s == 3:
                    print("Digit error!")
                    exit(-1)
            self.Token = ''.join(temp)  # 输入内容
            self.Type = 'CONST_ID'
            self.Value = float(self.Token)  # 强制转换
            self.Address = 'null'
            return i + 1
        elif ch == '*':  # 识别*或**
            if len(stream) != 1 and stream[1] == '*':
                self.Token = '**'
                self.Type = 'POWER'
                self.Value = 0.0
                self.Address = 'null'
                return 2
            else:
                self.Token = '*'
                self.Type = 'MUL'
                self.Value = 0.0
                self.Address = 'null'
                return 1
        elif ch == '/':  # 识别除号/或者注释号//
            if len(stream) != 1 and stream[1] == '/':
                self.Token = '//'
                self.Type = 'COMMENT'
                self.Value = 0.0
                self.Address = 'null'
                return stream.index('\n') + 1  # 返回注释的长度
            else:
                self.Token = '/'
                self.Type = 'DIV'
                self.Value = 0.0
                self.Address = 'null'
                return 1
        elif ch == '-':
            if len(stream) != 1 and stream[1] == '-':
                self.Token = '--'
                self.Type = 'COMMENT'
                self.Value = 0.0
                self.Address = 'null'
                return stream.index('\n') + 1  # 返回注释的长度
            else:
                self.Token = '-'
                self.Type = 'MINUS'
                self.Value = 0.0
                self.Address = 'null'
                return 1
        elif ch == '+':
            self.Token = '+'
            self.Type = 'PLUS'
            self.Value = 0.0
            self.Address = 'null'
            return 1
        elif ch == ',':
            self.Token = ','
            self.Type = 'COMMA'
            self.Value = 0.0
            self.Address = 'null'
            return 1
        elif ch == ';':
            self.Token = ';'
            self.Type = 'SEMICO'
            self.Value = 0.0
            self.Address = 'null'
            return 1
        elif ch == '(':
            self.Token = '('
            self.Type = 'L_BRACKET'
            self.Value = 0.0
            self.Address = 'null'
            return 1
        elif ch == ')':
            self.Token = ')'
            self.Type = 'R_BRACKET'
            self.Value = 0.0
            self.Address = 'null'
            return 1
        elif ch == '\n' or ch == ' ' or ch == '\t':
            self.Token = ch
            self.Type = 'WHITE_SPACE'
            self.Value = 0.0
            self.Address = 'null'
            return 1
        else:
            print('Token Error!')
            exit(-1)
            return -1


# Token记号类
class Token:
    # 初始化
    def __init__(self, T, Tstr, Tvalue, Tpoint):
        self.Type = T
        self.Token = Tstr
        self.Value = Tvalue
        self.Address = Tpoint


# 语法树涵盖{ + ，-，*，/，**，CONST_ID,T,FUNC }
class Tree:
    # 初始化Tree 参数是Token,例如'CONST_ID'
    def __init__(self, Token):
        self.Type = Token
        if self.Type in ['PLUS', 'MINUS', 'MUL', 'DIV', 'POWER']:
            self.leftChild = None
            self.rightChild = None
        elif self.Type == 'CONST_ID':
            self.value = 0.0
        elif self.Type == 'T':
            self.T = None
        elif self.Type == 'FUNC':
            self.child = None
            self.function = None


# 语法分析Parse
class Parse:
    # 初始化，参数是记号流TokenStream
    def __init__(self, Ts):
        self.Token = None
        self.tokens = Ts
        self.p = 0  # 记号流位置
        self.flag = 0  # 标记
        self.parameter = 0  #
        self.origin_x = 0
        self.origin_y = 0
        self.rot_ang = 0
        self.scale_x = 1
        self.scale_y = 1
        self.Tvalue = 0  # T值
        self.draw_List = []  # 画图参数，传入x，y轴数据

    # 建树，参数：比如Token为"CONST_ID",*arg为多参arg[0],arg[1]

    def BuildTree(self, Token, *arg):
        exprNode = Tree(Token)
        if Token == 'CONST_ID':
            exprNode.value = arg[0]
        elif Token == 'T':
            return exprNode
        elif Token == 'FUNC':
            exprNode.child = arg[1]
            exprNode.function = arg[0]
        else:
            exprNode.leftChild = arg[0]
            exprNode.rightChild = arg[1]
        return exprNode

    # 打印语法树blank是空格
    def printTree(self, tree, blank):
        for i in range(0, blank):
            print('  ', end='')  # 好打不回车
        if tree.Type in ['PLUS', 'MINUS', 'MUL', 'DIV', 'POWER']:
            print(tree.Type)
            if tree.leftChild != None:
                self.printTree(tree.leftChild, blank + 1)
            if tree.rightChild != None:
                self.printTree(tree.rightChild, blank + 1)
        elif tree.Type == 'FUNC':
            print(tree.function)
            if tree.child != None:
                self.printTree(tree.child, blank + 1)
        elif tree.Type == 'CONST_ID':
            print(tree.value)
        elif tree.Type == 'T':
            print('T')
            if tree.T != None:
                self.printTree(tree.T, blank + 1)

    # 获取记号，更新位置
    def fetchToken(self):
        return self.tokens[self.p]

    # 匹配终结符
    # tokens=[Token0,Token1,...]
    # tok为某终结符
    def matchToken(self, tok):
        self.Token = self.tokens[self.p]  # 获取当前Token
        self.p = self.p + 1  # 右移
        error = []
        if self.Token.Type != tok:  # 出错管理
            # print(tok+"\n")
            print(tok)
            for i in range(self.p - 3, self.p + 3):  # 这里有一个问题，p+3>len(tokens)时会出错
                error.append(self.tokens[i].Token)  # 显示出错附近的字符
            print('[!] Error')
            print("[!] 错误在\033[32m %s \033[0m附近\n" % (''.join(error)))  # 高亮显示字体颜色32号
            exit(-1)
        if self.p == len(self.tokens) and self.flag == 0:  # 扫描到最后一个Token，缺表达式时
            print('[!] 代码不完整\n')
            exit(-1)
        elif self.p == len(self.tokens) and self.flag == 1:  # 正常结束
            print('[!] 结束\n')
            plt.plot(*self.draw_List)  # plt.plot(x,y,format_string,**kwargs)
            plt.show()

            exit(0)
        else:
            self.Token = self.fetchToken()  # 接着,给Token赋值

    # Program  →  { Statement SEMICO }
    def program(self):
        while (1):
            self.flag = 0
            self.Token = self.fetchToken()
            if self.Token.Type == 'NONTOKEN':  # 源程序结束
                break
            self.statement()
            self.flag = 1  # 正常执行
            self.matchToken('SEMICO')  # 匹配句尾分号

    # Statement →  OriginStatement | ScaleStatement |  RotStatement    | ForStatement

    def statement(self):
        if self.Token.Type == 'ORIGIN':
            self.originStatement()
        elif self.Token.Type == 'SCALE':
            self.scaleStatement()
        elif self.Token.Type == 'ROT':
            self.rotStatement()
        else:
            self.forStatement()

    # OriginStatment → ORIGIN IS  L_BRACKET Expression COMMA Expression R_BRACKET

    def originStatement(self):
        self.matchToken('ORIGIN')
        self.matchToken('IS')
        self.matchToken('L_BRACKET')
        left_ptr = self.expression()
        print("Origin :")
        self.printTree(left_ptr, 1)  # origin左值
        self.matchToken('COMMA')
        right_ptr = self.expression()  # origin右值
        self.printTree(right_ptr, 1)
        print("*" * 20)
        self.matchToken('R_BRACKET')
        self.origin_x = self.Calculate(left_ptr)  # 递归计算
        self.origin_y = self.Calculate(right_ptr)

    # Statement →  ScaleStatement

    def scaleStatement(self):
        self.matchToken('SCALE')
        self.matchToken('IS')
        self.matchToken('L_BRACKET')
        Scale_X_Expr = self.expression()
        print("Scale :")
        self.printTree(Scale_X_Expr, 1)
        # print("*" * 20)
        self.matchToken('COMMA')
        Scale_Y_Expr = self.expression()
        self.printTree(Scale_Y_Expr, 1)
        print("*" * 20)
        self.matchToken('R_BRACKET')
        self.scale_x = self.Calculate(Scale_X_Expr)  # 递归计算
        self.scale_y = self.Calculate(Scale_Y_Expr)

    # Statement →  RotStatement

    def rotStatement(self):
        self.matchToken('ROT')
        self.matchToken('IS')
        rot_ptr = self.expression()
        print("ROT :")
        self.printTree(rot_ptr, 0)
        print("*" * 20)
        self.rot_ang = self.Calculate(rot_ptr)

    # Statement →  ForStatement
    def forStatement(self):
        self.matchToken('FOR')
        self.matchToken('T')
        self.matchToken('FROM')
        start_value = self.expression()  # 修改vlaue
        print("FROM :")
        self.printTree(start_value, 0)
        self.matchToken('TO')
        end_value = self.expression()
        print("TO :")
        self.printTree(end_value, 0);
        self.matchToken('STEP')
        print("STEP :")
        step_ptr = self.expression()
        self.printTree(step_ptr, 0)
        self.matchToken('DRAW')
        self.matchToken('L_BRACKET')
        x_Value = self.expression()
        self.matchToken('COMMA')
        y_Value = self.expression()
        self.matchToken('R_BRACKET')
        print("DRAW :")
        self.printTree(x_Value, 0)
        self.printTree(y_Value, 0)
        print('*' * 20)
        self.draw(start_value, end_value, step_ptr, x_Value, y_Value)  # 画图

    # Expression _-> Term   { ( PLUS | MINUS ) Term }

    def expression(self):
        left = self.term()
        while (1):
            if self.Token.Type == 'PLUS' or self.Token.Type == 'MINUS':
                Token_Tmp = self.Token
                self.matchToken(self.Token.Type)  # 确定加减号
                right = self.term()
                left = self.BuildTree(Token_Tmp.Type, left, right)  # 自上而下递归构建语法树
            else:
                break
        return left  # 此时的left是一个节点

    # term  ->  factor { ( MUL | DIV ) factor }

    def term(self):
        left = self.factor()  # 递归调用
        while (1):
            if self.Token.Type == 'MUL' or self.Token.Type == 'DIV':
                Token_Tmp = self.Token
                self.matchToken(self.Token.Type)
                right = self.factor()
                left = self.BuildTree(Token_Tmp.Type, left, right)
            else:
                break
        return left  # 此时的left也是一个节点

    # factor  	→ ( PLUS | MINUS ) factor | component

    def factor(self):
        if self.Token.Type == 'PLUS':
            self.matchToken('PLUS')  # 一元运算
            tree = self.factor()
        elif self.Token.Type == 'MINUS':
            self.matchToken('MINUS')
            padding = Tree('CONST_ID')
            padding.Value = 0.0  # 0-?
            right = self.factor()
            tree = self.BuildTree('MINUS', padding, right)
        else:
            tree = self.component()
        return tree

    # Component 	→ Atom [ POWER Component ]

    def component(self):
        left = self.atom()
        Token_Tmp = 'null'
        # if self.p != len(self.tokens)-1:
        Token_Tmp = self.tokens[self.p]
        if Token_Tmp.Type == 'POWER':  # 识别**
            self.matchToken('POWER')
            right = self.component()
            left = self.BuildTree('POWER', left, right)
        return left

    # Atom → CONST_ID| T | FUNC L_BRACKET Expression R_BRACKET | L_BRACKET Expression R_BRACKET
    def atom(self):
        if self.Token.Type == 'CONST_ID':
            Token_Tmp = self.Token
            self.matchToken('CONST_ID')
            tree = self.BuildTree('CONST_ID', Token_Tmp.Value)  #
        elif self.Token.Type == 'T':
            Token_Tmp = self.Token
            self.matchToken('T')
            tree = self.BuildTree('T')
        elif self.Token.Type == 'FUNC':
            Token_Tmp = self.Token
            self.matchToken('FUNC')
            self.matchToken('L_BRACKET')
            tree = self.BuildTree('FUNC', Token_Tmp.Address, self.expression())
            self.matchToken('R_BRACKET')
        else:
            self.matchToken('L_BRACKET')
            tree = self.expression()
            self.matchToken('R_BRACKET')
        return tree

    def Calculate(self, tree):
        if tree.Type == 'PLUS':
            leftValue = self.Calculate(tree.leftChild)
            rightValue = self.Calculate(tree.rightChild)
            return leftValue + rightValue
        if tree.Type == 'MINUS':
            leftValue = self.Calculate(tree.leftChild)
            rightValue = self.Calculate(tree.rightChild)
            return leftValue - rightValue
        if tree.Type == 'MUL':
            leftValue = self.Calculate(tree.leftChild)
            rightValue = self.Calculate(tree.rightChild)
            return leftValue * rightValue
        if tree.Type == 'DIV':
            leftValue = self.Calculate(tree.leftChild)
            rightValue = self.Calculate(tree.rightChild)
            if rightValue == 0:
                print('Error: Divided by zero!')
                exit(-1)
            return leftValue / rightValue
        if tree.Type == 'POWER':
            leftValue = self.Calculate(tree.leftChild)
            rightValue = self.Calculate(tree.rightChild)
            return leftValue ** rightValue
        if tree.Type == 'FUNC':
            return eval(tree.function)(self.Calculate(tree.child))  # eval() 将字符串当成有效的表达式 来求值并返回计算结果
        if tree.Type == 'CONST_ID':
            return tree.value
        if tree.Type == 'T':
            return eval('self.Tvalue')

    # 比例变换→旋转变换→平移变换
    # 函数用在for语句
    def draw(self, start_value, end_value, step_ptr, x_Value, y_Value):
        T_start = self.Calculate(start_value)
        T_end = self.Calculate(end_value)
        step = self.Calculate(step_ptr)
        self.Tvalue = T_start  # init
        xs = []
        ys = []
        while self.Tvalue < T_end:
            x = self.Calculate(x_Value)
            y = self.Calculate(y_Value)
            temp_x = x * self.scale_x  # Scale比例变换
            temp_y = y * self.scale_y
            temp = temp_x * cos(self.rot_ang) + temp_y * sin(self.rot_ang)  # 课件上公式-旋转
            temp_y = temp_y * cos(self.rot_ang) - temp_x * sin(self.rot_ang)
            temp_x = temp
            Now_x = temp_x + self.origin_x  # 平移变换
            Now_y = temp_y + self.origin_y
            xs.append(Now_x)
            ys.append(Now_y)
            self.Tvalue = self.Tvalue + step
        x = self.Calculate(x_Value)  # 最后一个像素点
        y = self.Calculate(y_Value)
        temp_x = x * self.scale_x
        temp_y = y * self.scale_y
        temp = temp_x * cos(self.rot_ang) + temp_y * sin(self.rot_ang)
        temp_y = temp_y * cos(self.rot_ang) - temp_x * sin(self.rot_ang)
        temp_x = temp
        Now_x = temp_x + self.origin_x
        Now_y = temp_y + self.origin_y
        xs.append(Now_x)
        ys.append(Now_y)
        self.Tvalue = self.Tvalue + step
        self.draw_List.append(xs)
        self.draw_List.append(ys)


if __name__ == '__main__':
    fileName = input("[+] LYS Input File:")
    plt.figure()
    with open(fileName, 'r') as fp:
        Context = fp.read()
        Context = Context.upper()  # 大写
        TokenStream = []
        Scanner = Scanner()
    print("\033[35m[+] 记号流\n")
    while (1):
        p = Scanner.getToken(Context)  # getToken的返回值是字符长度
        if (p >= len(Context)):
            break
        if Scanner.Type != 'WHITE_SPACE' and Scanner.Type != 'COMMENT':
            TokenStream.append(Token(Scanner.Type, Scanner.Token, Scanner.Value, Scanner.Address))
        Context = Context[p:]  # 截取字符

    for i in range(0, len(TokenStream)):
        print("%12s%12s%12f%12s" % (
        TokenStream[i].Type, TokenStream[i].Token, TokenStream[i].Value, TokenStream[i].Address))
    print("\033[32m[+] 语法树\n\033[0m")
    # print(len(TokenStream))
    cp = Parse(TokenStream)
    cp.program()
