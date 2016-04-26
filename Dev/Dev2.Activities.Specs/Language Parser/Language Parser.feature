﻿Feature: Language Parser
	In order to get validation errors
	As a Warewolf user
	I want proper validation messages for incorrect inputs in all the tools

Scenario Outline: Parse text input
	Given I have text '<variable>' as input
    When I validate
	Then has error will be '<error>'.
	And the error message will be '<message>'
Examples:
	| Name | variable                      | error | message                                                             |
	| 1    | [[var]]                       | false |                                                                     |
	| 2    | [[var1]]                      | false |                                                                     |
	| 3    | [[var1]]asdf<[[var]]          | false |                                                                     |
	| 4    | [[var@]]                      | true  | Variable name [[var@]] contains invalid character(s)                |
	| 5    | [[var#]]                      | true  | Variable name [[var#]] contains invalid character(s)                |
	| 6    | [[var$]]                      | true  | Variable name [[var$]] contains invalid character(s)                |
	| 7    | [[var%]]                      | true  | Variable name [[var%]] contains invalid character(s)                |
	| 8    | [[var^]]                      | true  | Variable name [[var^]] contains invalid character(s)                |
	| 9    | [[var&]]                      | true  | Variable name [[var&]] contains invalid character(s)                |
	| 10   | [[var]]00]]                   | true  | Invalid region detected: A close ]] without a related open [[       |
	| 11   | [[var]]@]]                    | true  | Invalid region detected: A close ]] without a related open [[       |
	| 12   | [[var]]]]                     | true  | Invalid region detected: A close ]] without a related open [[       |
	| 13   | [[[[var]]                     | true  | Invalid region detected: An open [[ without a related close ]]      |
	| 14   | [[(1var)]]                    | true  | Variable name [[(1var)]] contains invalid character(s)              |
	| 15   | [[1var)]]                     | true  | Variable name [[1var)]] begins with a number                        |
	| 16   | [[var.()]]                    | true  | Variable name [[var.()]] contains invalid character(s)              |
	| 17   | [[]]                          | true  | Variable name [[]] contains invalid character(s)                    |
	| 18   | [[()]]                        | true  | Variable name [[()]] contains invalid character(s)                  |
	| 19   | [[(1)]]                       | true  | Variable name [[(1)]] contains invalid character(s)                 |
	| 20   | [[var  ]]                     | true  | Variable name [[var  ]] contains invalid character(s)               |
	| 21   | [[var~]]                      | true  | Variable name [[var~]] contains invalid character(s)                |
	| 22   | [[var+]]                      | true  | Variable name [[var+]] contains invalid character(s)                |
	| 23   | [[var]a]]                     | true  | Variable name [[var]a]] contains invalid character(s)               |
	| 24   | [[var[a]]                     | true  | Variable name [[var[a]] contains invalid character(s)               |
	| 25   | [[var[[a]]]]                  | true  | Variable name [[var[[a]]]] contains invalid character(s)            |
	| 26   | [[var[[]]                     | true  | Variable name [[var[[]] contains invalid character(s)               |
	| 27   | [[var[[1]]]]                  | true  | Variable name [[var[[1]]]] contains invalid character(s)            |
	| 28   | [[var.a]]                     | false |                                                                     |
	| 30   | [[var]][[var]]                | false |                                                                     |
	| 31   | [[a]].[[b]]                   | false |                                                                     |
	| 32   | [[[[a]].[[b]]]]               | true  | invalid variable name                                               |
	| 33   | [[[[a]].[[b]]]]cd]]           | true  | Invalid region detected: A close ]] without a related open [[       |
	| 34   | [[var*]]                      | true  | Variable name [[var*]] contains invalid character(s)                |
	| 36   | [[@var]]                      | true  | Variable name [[@var]] contains invalid character(s)                |
	| 37   | [[#var]]                      | true  | Variable name [[#var]] contains invalid character(s)                |
	| 38   | [[$var]]                      | true  | Variable name [[$var]] contains invalid character(s)                |
	| 39   | [[%var]]                      | true  | Variable name [[%var]] contains invalid character(s)                |
	| 40   | [[^var]]                      | true  | Variable name [[^var]] contains invalid character(s)                |
	| 41   | [[&var]]                      | true  | Variable name [[&var]] contains invalid character(s)                |
	| 42   | [[*var]]                      | true  | Variable name [[*var]] contains invalid character(s)                |
	| 43   | [[(var]]                      | true  | Variable name [[(var]] contains invalid character(s)                |
	| 44   | [[var]](var)]]                | true  | Invalid region detected: A close ]] without a related open [[       |
	| 45   | [[var,]]                      | true  | Variable name [[var,]] contains invalid character(s)                |
	| 46   | [[var/]]                      | true  | Variable name [[var/]] contains invalid character(s)                |
	| 47   | [[var:]]                      | true  | Variable name [[var:]] contains invalid character(s)                |
	| 48   | [[var"]]                      | true  | Variable name [[var"]] contains invalid character(s)                |
	| 49   | [[var']]                      | true  | Variable name [[var']] contains invalid character(s)                |
	| 50   | [[var;]]                      | true  | Variable name [[var;]] contains invalid character(s)                |
	| 51   | [[var?]]                      | true  | Variable name [[var?]] contains invalid character(s)                |
	| 52   | [[var 1]]                     | true  | Variable name [[var 1]] contains invalid character(s)               |
	| 53   | [[:var 1]]                    | true  | Variable name [[:var 1]] contains invalid character(s)              |
	| 54   | [[,var]]                      | true  | Variable name [[,var]] contains invalid character(s)                |
	| 55   | [[test,var]]                  | true  | Variable name [[test,var]] contains invalid character(s)            |
	| 56   | [[test. var]]                 | true  | Variable name [[test. var]] contains invalid character(s)           |
	| 57   | [[test.var]]                  | false |                                                                     |
	| 58   | [[test. 1]]                   | true  | Variable name [[test. 1]] contains invalid character(s)             |
	| 59   | [[rec().a]]                   | false |                                                                     |
	| 60   | [[rec(1).a]]                  | false |                                                                     |
	| 61   | [[rec(*).a]]                  | false |                                                                     |
	| 62   | [[rec(*).&]]                  | true  | Variable name [[rec(*).&]] contains invalid character(s)            |
	| 63   | [[rec(),a]]                   | true  | Variable name [[rec(),a]] contains invalid character(s)             |
	| 64   | [[rec()*a]]                   | true  | Variable name [[rec()*a]] contains invalid character(s)             |
	| 65   | [[rec()&a]]                   | true  | Variable name [[rec()&a]] contains invalid character(s)             |
	| 66   | [[rec()!a]]                   | true  | Variable name [[rec()!a]] contains invalid character(s)             |
	| 67   | [[rec()@a]]                   | true  | Variable name [[rec()@a]] contains invalid character(s)             |
	| 68   | [[rec()(a]]                   | true  | Variable name [[rec()(a]] contains invalid character(s)             |
	| 69   | [[rec()%`a]]                  | true  | Variable name [[rec()%`a]] contains invalid character(s)            |
	| 70   | [[rec()         a]]           | true  | Variable name [[rec()         a]] contains invalid character(s)     |
	| 71   | [[rec(1)]]                    | false |                                                                     |
	| 72   | [[rec(1).[[rec().1]]]]        | true  | Variable name [[rec(1).[[rec().1]]]] contains invalid character(s)  |
	| 73   | [[rec(a).[[rec().a]]]]        | true  | Variable name [[rec(a).[[rec().a]]]] contains invalid character(s)  |
	| 74   | [[rec().[[rec().a]]]]         | true  | Variable name [[rec().[[rec().a]]]] contains invalid character(s)   |
	| 75   | [[rec().[[b]]]]               | true  | Variable name [[rec().[[b]]]] contains invalid character(s)         |
	| 76   | [[{{rec(_).a}}]]]             | true  | Variable name [[{{rec(_).a}}]]] contains invalid character(s)       |
	| 77   | [[*[{{rec(_).a}}]]]           | true  | Variable name [[*[{{rec(_).a}}]]] contains invalid character(s)     |
	| 78   | [[rec(23).[[var}]]]]          | true  | Variable name [[rec(23).[[var}]]]] contains invalid character(s)    |
	| 79   | [[rec(23).[[var*]]]]          | true  | Variable name [[rec(23).[[var*]]]] contains invalid character(s)    |
	| 80   | [[rec(23).[[var%^&%]]]]       | true  | Variable name [[rec(23).[[var%^&%]]]] contains invalid character(s) |
	| 81   | [[rec().a]]234234]]           | true  | Invalid region detected: A close ]] without a related open [[       |
	| 82   | [[rec().a]]=]]                | true  | Invalid region detected: A close ]] without a related open [[       |
	| 83   | [[rec()..]]                   | true  | Variable name [[rec()..]] contains invalid character(s)             |
	| 84   | [[rec().a.b]]                 | false |                                                                     |
	| 85   | [[rec().a]].a]]               | true  | Invalid region detected: A close ]] without a related open [[       |
	| 86   | [[rec()]]                     | false |                                                                     |
	| 87   | [[rec(@).a]]                  | true  | Recordset index (@) contains invalid character(s)                   |
	| 88   | [[rec(#).a]]                  | true  | Recordset index (#) contains invalid character(s)                   |
	| 89   | [[rec($).a]]                  | true  | Recordset index ($) contains invalid character(s)                   |
	| 90   | [[rec(%).a]]                  | true  | Recordset index (%) contains invalid character(s)                   |
	| 91   | [[rec(^).a]]                  | true  | Recordset index (^) contains invalid character(s)                   |
	| 92   | [[rec(&).a]]                  | true  | Recordset index (&) contains invalid character(s)                   |
	| 93   | [[rec(*).a]]                  | false |                                                                     |
	| 94   | [[rec(().a]]                  | true  | Recordset index (() contains invalid character(s)                   |
	| 95   | [[rec()).a]]                  | true  | Recordset index ()) contains invalid character(s)                   |
	| 96   | [[rec(+).a]]                  | true  | Recordset index (+) contains invalid character(s)                   |
	| 97   | [[rec(-).a]]                  | true  | Recordset index (-) contains invalid character(s)                   |
	| 98   | [[rec(!).a]]                  | true  | Recordset index (!) contains invalid character(s)                   |
	| 99   | [[rec(q).a]]                  | true  | Recordset index (q) contains invalid character(s)                   |
	| 100  | [[rec(w).a]]                  | true  | Recordset index (w) contains invalid character(s)                   |
	| 101  | [[rec(e).a]]                  | true  | Recordset index (e) contains invalid character(s)                   |
	| 102  | [[rec(r).a]]                  | true  | Recordset index (r) contains invalid character(s)                   |
	| 103  | [[rec(t).a]]                  | true  | Recordset index (t) contains invalid character(s)                   |
	| 104  | [[rec(y).a]]                  | true  | Recordset index (y) contains invalid character(s)                   |
	| 105  | [[rec(u).a]]                  | true  | Recordset index (u) contains invalid character(s)                   |
	| 106  | [[rec(d).a]]                  | true  | Recordset index (d) contains invalid character(s)                   |
	| 107  | [[rec(b).a]]                  | true  | Recordset index (b) contains invalid character(s)                   |
	| 108  | [[rec(.).a]]                  | true  | Recordset index (.) contains invalid character(s)                   |
	| 109  | [[rec(:).a]]                  | true  | Recordset index (:) contains invalid character(s)                   |
	| 110  | [[rec(,).a]]                  | true  | Recordset index (,) contains invalid character(s)                   |
	| 111  | [[rec"()".a]]                 | true  | Variable name [[rec"()".a]] contains invalid character(s)           |
	| 112  | [[rec'()'.a]]                 | true  | Variable name [[rec'()'.a]] contains invalid character(s)           |
	| 113  | [[rec").a]]                   | true  | Variable name [[rec").a]] contains invalid character(s)             |
	| 114  | [[rec{a]]                     | true  | Variable name [[rec{a]] contains invalid character(s)               |
	| 115  | [[rec{a}]]                    | true  | Variable name [[rec{a}]] contains invalid character(s)              |
	| 116  | [[rec()*.a]]                  | true  | Variable name [[rec()*.a]] contains invalid character(s)            |
	| 117  | [[rec().a[[a]]                | true  | Variable name [[rec().a[[a]] contains invalid character(s)          |
	| 118  | [[rec().a]][[a]]              | false |                                                                     |
	| 119  | [[rec().a]].[[a]]             | false |                                                                     |
	| 120  | asdf[[rec().a]]*[[a]]asdf     | false |                                                                     |
	| 121  | [[v]],[[a]][[rec().a]]@[[a]]  | false |                                                                     |
	| 122  | [[v]],[[a]][[rec(*).a]]@[[a]] | false |                                                                     |
	| 123  | [[rec([[a]]).a]]              | false |                                                                     |
	| 124  | [[rec([[rec(*).a]]).a]]       | false |                                                                     |
	| 125  | [[rec().a]]%[[a]]             | false |                                                                     |
	| 126  | a[[rec([[[[b]]]]).a]]@        | true  | Variable name a[[rec([[[[b]]]]).a]]@ contains invalid character(s)  |
	| 127  | [[rec().a]]&[[a]]             | false |                                                                     |
	| 128  | [[rec().a.b*]]                | true  | Variable name [[rec().a.b*]] contains invalid character(s)          |
	| 129  | [[rec.a*]]                    | true  | Variable name [[rec.a*]] contains invalid character(s)              |
	| 130  | [[rec&.a]]                    | true  | Variable name [[rec&.a]] contains invalid character(s)              |
	| 131  | [[rec.a.b.*]]                 | true  | Variable name [[rec.a.b.*]] contains invalid character(s)           |
	| 132  | [[rec().a.b.*]]               | true  | Variable name [[rec().a.b.*]] contains invalid character(s)         |
	| 133  | [[rec().a.b().c]]             | false |                                                                     |
	| 134  | [[rec().a.b().c(*).d]]        | false |                                                                     |
	| 135  | [[rec().a.b().c(*)]]          | false |                                                                     |
	| 136  | [[rec(*).a.b().c(*)]]         | false |                                                                     |
	| 137  | [[rec(*).a.b().c(*)           | true  | Variable name [[rec(*).a.b().c(*) contains invalid character(s)     |
