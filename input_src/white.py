"""
    pygments.styles.white
    ~~~~~~~~~~~~~~~~~~~~~~~

    The white highlighting style.

    :copyright: Copyright 2006-2023 by the Pygments team, see AUTHORS.
    :license: BSD, see LICENSE for details.
"""

from pygments.style import Style
from pygments.token import Keyword, Name, Comment, String, Error, \
     Number, Operator, Generic, Whitespace


class WhiteStyle(Style):
    """
    The white style.
    """

    styles = {
        Whitespace:                "#ffffff",
        Comment:                   "italic #ffffff",
        Comment.Preproc:           "noitalic #ffffff",

        Keyword:                   "bold #ffffff",
        Keyword.Pseudo:            "nobold #ffffff",
        Keyword.Type:              "nobold #ffffff",

        Operator:                  "#ffffff",
        Operator.Word:             "bold #ffffff",

        Name.Builtin:              "#ffffff",
        Name.Function:             "#ffffff",
        Name.Class:                "bold #ffffff",
        Name.Namespace:            "bold #ffffff",
        Name.Exception:            "bold #ffffff",
        Name.Variable:             "#ffffff",
        Name.Constant:             "#ffffff",
        Name.Label:                "#ffffff",
        Name.Entity:               "bold #ffffff",
        Name.Attribute:            "#ffffff",
        Name.Tag:                  "bold #ffffff",
        Name.Decorator:            "#ffffff",

        String:                    "#ffffff",
        String.Doc:                "italic #ffffff",
        String.Interpol:           "bold #ffffff",
        String.Escape:             "bold #ffffff",
        String.Regex:              "#ffffff",
        String.Symbol:             "#ffffff",
        String.Other:              "#ffffff",
        Number:                    "#ffffff",

        Generic.Heading:           "bold #ffffff",
        Generic.Subheading:        "bold #ffffff",
        Generic.Deleted:           "#ffffff",
        Generic.Inserted:          "#ffffff",
        Generic.Error:             "#ffffff",
        Generic.Emph:              "italic #ffffff",
        Generic.Strong:            "bold #ffffff",
        Generic.Prompt:            "bold #ffffff",
        Generic.Output:            "#ffffff",
        Generic.Traceback:         "#ffffff",

        Error:                     "border:#ffffff"
    }
