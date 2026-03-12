%{
#include "parser.tab.h"
#include <string.h>
#include <stdlib.h>
%}

%%

"android:id"            { return ANDROID_ID; }
"android:layout_width"  { return LAYOUT_WIDTH; }
"android:layout_height" { return LAYOUT_HEIGHT; }
"android:padding"       { return PADDING; }
"android:checkedButton" { return CHECKED_BUTTON; }
"android:progress"      { return PROGRESS; }
"android:max"           { return MAX; }
"wrap_content"          { return WRAP_CONTENT; }
"match_parent"          { return MATCH_PARENT; }
"android:item_count" { return ITEM_COUNT; }

\"?"-"?[0-9]+\"?    { yylval.num = atoi(yytext + (yytext[0] == '\"' ? 1 : 0)); return NUMBER; }

\"[^\"]+\"              { 
{ yylval.str = strdup(yytext); return STRING_VAL; }
                        }

[ \t\n\r]+              { /* ignore */ }
"<"                     { return LT; }
">"                     { return GT; }
"/>"                    { return SLASH_GT; }
"</"                    { return LT_SLASH; }
"="                     { return EQ; }

[a-zA-Z0-9:]+            { yylval.str = strdup(yytext); return VIEW_TYPE; }

.                       { ; }

%%

int yywrap() { return 1; }