%% FILENAME: @FILE@
%% AUTHOR:   @AUTHOR@
%% DATE:     @DATE@
%% @CVS_REVISION@
%% DESCRIPTION:

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{myClass}[2004/12/11]
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{aticle}}
\ProcessOptions\relax
\LoadClass{article}
