#include "highlighter.h"

Highlighter::Highlighter(QTextDocument *parent)
    : QSyntaxHighlighter(parent)
{
    HighlightingRule rule;

    keywordFormat.setForeground(QBrush("#EBC23A", Qt::SolidPattern));
    QStringList keywordPatterns;
    keywordPatterns << "\\buniform\\b" << "\\bsampler2D\\b" << "\\bvarying\\b" << "\\bconst\\b"
                    << "\\bvec\\d\\b" << "\\bmat\\d\\b" << "\\bfloat\\b" << "\\bvoid\\b" << "\\bint\\b"
                    << "\\bif\\b" << "\\belse\\b" << "\\bfor\\b";
    foreach (const QString &pattern, keywordPatterns)
    {
        rule.pattern = QRegExp(pattern);
        rule.format = keywordFormat;
        highlightingRules.append(rule);
    }

    builtinFunctionFormat.setForeground(QBrush("#20B000", Qt::SolidPattern));
    keywordPatterns.clear();
    keywordPatterns << "\\bradians\\b" << "\\bdegrees\\b" << "\\bsin\\b" << "\\bcos\\b"
                    << "\\btan\\b" << "\\basin\\b" << "\\bacos\\b" << "\\batan\\b"
                    << "\\batan\\b" << "\\bpow\\b" << "\\bexp\\b" << "\\blog\\b"
                    << "\\bexp2\\b" << "\\blog2\\b" << "\\bsqrt\\b" << "\\binversesqrt\\b"
                    << "\\babs\\b" << "\\bsign\\b" << "\\bfloor\\b" << "\\bceil\\b"
                    << "\\bfract\\b" << "\\bmod\\b" << "\\bmin\\b" << "\\bmax\\b"
                    << "\\bclamp\\b" << "\\bmix\\b" << "\\bstep\\b" << "\\bsmoothstep\\b"
                    << "\\blength\\b" << "\\bdistance\\b" << "\\bdot\\b" << "\\bcross\\b"
                    << "\\bnormalize\\b" << "\\bfaceforward\\b" << "\\breflect\\b" << "\\brefract\\b"
                    << "\\bmatrixCompMult\\b" << "\\blessThan\\b" << "\\blessThanEqual\\b" << "\\bgreaterThan\\b"
                    << "\\bgreaterThanEqual\\b" << "\\bequal\\b" << "\\bnotEqual\\b" << "\\bany\\b"
                    << "\\ball\\b" << "\\bnot\\b" << "\\btexture2D\\b" << "\\btextureCube\\b";
    foreach (const QString &pattern, keywordPatterns)
    {
        rule.pattern = QRegExp(pattern);
        rule.format = builtinFunctionFormat;
        highlightingRules.append(rule);
    }

    precisionFormat.setForeground(QBrush("#f02000", Qt::SolidPattern));
    keywordPatterns.clear();
    keywordPatterns << "\\blowp\\b" << "\\bmediump\\b" << "\\bhighp\\b";
    foreach (const QString &pattern, keywordPatterns)
    {
        rule.pattern = QRegExp(pattern);
        rule.format = precisionFormat;
        highlightingRules.append(rule);
    }

    numberFormat.setForeground(QBrush("#D66680", Qt::SolidPattern));
    //rule.pattern = QRegExp("\\b\\d+\\.\\d*\\b");
    rule.pattern = QRegExp("\\b\\d+\\.(\\d+\\b)?|\\.\\d+\\b|\\b\\d+\\b");
    rule.format = numberFormat;
    highlightingRules.append(rule);

    singleLineCommentFormat.setForeground(QBrush("#55FFFF", Qt::SolidPattern));
    rule.pattern = QRegExp("//[^\n]*");
    rule.format = singleLineCommentFormat;
    highlightingRules.append(rule);

    multiLineCommentFormat.setForeground(QBrush("#55FFFF", Qt::SolidPattern));
    commentStartExpression = QRegExp("/\\*");
    commentEndExpression = QRegExp("\\*/");

    quotationFormat.setForeground(QBrush("#FF55FF", Qt::SolidPattern));
    rule.pattern = QRegExp("\".*\"");
    rule.format = quotationFormat;
    highlightingRules.append(rule);
}

void Highlighter::highlightBlock(const QString &text)
{
    foreach (const HighlightingRule &rule, highlightingRules)
    {
        QRegExp expression(rule.pattern);
        int index = expression.indexIn(text);
        while (index >= 0)
        {
            int length = expression.matchedLength();
            setFormat(index, length, rule.format);
            index = expression.indexIn(text, index + length);
        }
    }
    setCurrentBlockState(0);

    int startIndex = 0;
    if (previousBlockState() != 1)
        startIndex = commentStartExpression.indexIn(text);

    while (startIndex >= 0)
    {
        int endIndex = commentEndExpression.indexIn(text, startIndex);
        int commentLength;
        if (endIndex == -1)
        {
            setCurrentBlockState(1);
            commentLength = text.length() - startIndex;
        }
        else
        {
            commentLength = endIndex - startIndex + commentEndExpression.matchedLength();
        }
        setFormat(startIndex, commentLength, multiLineCommentFormat);
        startIndex = commentStartExpression.indexIn(text, startIndex + commentLength);
    }
}
