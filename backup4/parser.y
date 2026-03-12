%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void yyerror(const char *s);
extern int yylex();
extern FILE *yyin;

char *ids_table[100];
int ids_count = 0;

/* Μεταβλητές για το 3ο Σκέλος */
int expected_items = -1; 
int actual_items = 0;

void check_and_add_id(char *id_name) {
    for (int i = 0; i < ids_count; i++) {
        if (strcmp(ids_table[i], id_name) == 0) {
            printf("\nSFALMA (a): To ID '%s' xrisimopoieitai idi!\n", id_name);
            return;
        }
    }
    ids_table[ids_count++] = strdup(id_name);
}
%}

%union {
    int num;
    char *str;
}

%token WRAP_CONTENT MATCH_PARENT ITEM_COUNT
%token <str> VIEW_TYPE STRING_VAL
%token <num> NUMBER
%token LT GT SLASH_GT LT_SLASH EQ
%token ANDROID_ID LAYOUT_WIDTH LAYOUT_HEIGHT PADDING CHECKED_BUTTON PROGRESS MAX


%%

layout: element { 
    /* Έλεγχος 3ου σκέλους */
    if (expected_items == -1) {
        printf("\nSFALMA (3o Skelos): To xaraktiristiko android:item_count einai ypoxrewtiko!\n");
    } else if (actual_items != expected_items) {
        printf("\nSFALMA (3o Skelos): Vrethikan %d stoixeia, alla to item_count dilwse %d!\n", actual_items, expected_items);
    }
    printf("\nApotelesma: To programma einai SYNTAKTIKA ORTHO.\n"); 
} ;

/* Αλλάζουμε το VIEW_TYPE σε STRING_VAL για να δέχεται οποιοδήποτε tag (π.χ. LinearLayout) */
element:
      LT VIEW_TYPE attributes GT elements LT_SLASH VIEW_TYPE GT
    | LT VIEW_TYPE attributes SLASH_GT
    | LT STRING_VAL attributes GT elements LT_SLASH STRING_VAL GT
    | LT STRING_VAL attributes SLASH_GT
    ;

/* Αυξάνουμε τον μετρητή για κάθε στοιχείο-παιδί που βρίσκουμε */
elements: 
    element { actual_items++; } elements 
    | /* empty */ 
    ;
attributes: attribute attributes |

attribute:
      ANDROID_ID EQ STRING_VAL   { check_and_add_id($3); }
    | LAYOUT_WIDTH EQ STRING_VAL
    | LAYOUT_WIDTH EQ NUMBER     { if ($3 <= 0) printf("ΣΦΑΛΜΑ (b): To width prepei na einai thetiko!\n"); }
    | LAYOUT_HEIGHT EQ STRING_VAL
    | LAYOUT_HEIGHT EQ NUMBER    { if ($3 <= 0) printf("ΣΦΑΛΜΑ (b): To height prepei na einai thetiko!\n"); }
    | PADDING EQ NUMBER          { if ($3 <= 0) printf("ΣΦΑΛΜΑ (c): To padding prepei na einai thetiko (Vrethike: %d)\n", $3); }
    | PROGRESS EQ NUMBER         { if ($3 < 0) printf("ΣΦΑΛΜΑ (d): To progress den mporei na einai arnitiko!\n"); }
    | MAX EQ NUMBER              { if ($3 <= 0) printf("ΣΦΑΛΜΑ (d): To max prepei na einai thetiko!\n"); }
    | ITEM_COUNT EQ NUMBER       { 
        if ($3 <= 0) printf("ΣΦΑΛΜΑ (3ο Σκέλος): To item_count πρέπει να είναι θετικό!\n");
        else expected_items = $3; 
      }
    | VIEW_TYPE EQ STRING_VAL
    | STRING_VAL EQ STRING_VAL   /* Κανόνας "ασφαλείας" για να δέχεται match_parent κτλ */
    ;

%%

void yyerror(const char *s) { fprintf(stderr, "Syntaktiko Sfalma: %s\n", s); }

int main(int argc, char **argv) {
    if(argc > 1) yyin = fopen(argv[1], "r");
    yyparse();
    return 0;
}