### 非終端記号・トークンの型指定
TBW

### lexからyaccへの値の受け渡し
単にトークン種別が分かればいい場合はyaccの`%token`で定義されたトークンを返す。

そうでなければ、lexで終端記号をトークンの型に変換してyaccに渡す。
以下にその手順を示す。

Step 1: yaccの`%union`に渡したい意味の型を持つ変数を宣言する。それを使って型付きトークンを宣言する。
```
%union{
  int ival;
  double rval;
  const char* cval;
}

%token <ival> INTC
%token <cval> VAR
```

Step2: lexでトークンを返す前に`yylval`に`yytext`から作成した値を代入する。
```
{digit}+ {
  sscanf(yytext, "%d", &yylval.ival);
  return INTC;
}
{var} {
  yylval.cval = yytext;
  return VAR;
}
```

これでyaccの構文定義においてトークンの意味値は指定した型を持つ。
例えば、
```
%type <rval> expr
%%
expr: INTC {$$ = (double) $1;}
    ;
%%
```
とすれば、doubleの`expr`の意味値はintであるトークン`INTC`の意味値を型変換の上で代入したことになる。

### noyywrap

`ch5/memcalc/memcalc.l`に以下のオプションを追加した。
```
%option noyywrap
```
デフォルトではflexが生成するソースにおいてyywrap関数がコールされる。
yywrapの定義を提供するためにはyywrap関数を手書きするかライブラリのリンクが必要となる。
どちらも手間なので、yywrapをコールしないソースを生成するように指示するのがnoyywrapオプションである。