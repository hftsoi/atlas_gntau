'''
atlasplots.atlasstyle
~~~~~~~~~~~~~~~~~~~~~

Python implementation of the ATLAS PubCom style guide for plots in ROOT:
    https://twiki.cern.ch/twiki/bin/view/AtlasProtected/PubComPlotStyle

This implementation uses ROOT fonts with precision = 3, where text sizes are
given in pixels. Using text sizes in pixels is useful for canvases with
multiple TPads of different sizes, as the text size will not depend on the
dimensions of the pad. The default font used by the ATLAS style is Arial (ROOT
font 43).

For general instructions on formatting text in ROOT, refer to,
    https://root.cern.ch/doc/master/classTAttText.html

Modified from:
:copyright: (c) 2020-2021 Joey Carter.
:license: MIT, see :ref:`LICENSE <license>` for more details.
'''

from typing import Optional
import ROOT

def atlas_style(tsize: int = 29) -> ROOT.TStyle:
    """Defines the "official" ATLAS plot style.
    Parameters
    ----------
    tsize : float, optional
        Text size in pixels (default: 29).
    Returns
    -------
    ROOT.TStyle
        The TStyle object defining the ATLAS Style.
    """
    atlasStyle = ROOT.TStyle("ATLAS", "Atlas Style")

    # Use plain black on white colors
    icol = 0  # White
    atlasStyle.SetFrameBorderMode(icol)
    atlasStyle.SetFrameFillColor(icol)
    atlasStyle.SetCanvasBorderMode(icol)
    atlasStyle.SetCanvasColor(icol)
    atlasStyle.SetPadBorderMode(icol)
    atlasStyle.SetPadBorderSize(icol)
    atlasStyle.SetPadColor(icol)
    atlasStyle.SetStatColor(icol)

    # Set the paper & margin sizes
    atlasStyle.SetPaperSize(20, 26)

    # Set margin sizes
    atlasStyle.SetPadTopMargin(0.05)
    atlasStyle.SetPadRightMargin(0.05)
    atlasStyle.SetPadBottomMargin(0.16)
    atlasStyle.SetPadLeftMargin(0.16)

    # Set title offsets (for axis labels)
    atlasStyle.SetTitleXOffset(1.4)
    atlasStyle.SetTitleYOffset(1.4)

    # Set font
    font = 43  # Arial

    atlasStyle.SetTextFont(font)
    atlasStyle.SetTextSize(tsize)

    atlasStyle.SetLabelFont(font, "x")
    atlasStyle.SetTitleFont(font, "x")
    atlasStyle.SetLabelFont(font, "y")
    atlasStyle.SetTitleFont(font, "y")
    atlasStyle.SetLabelFont(font, "z")
    atlasStyle.SetTitleFont(font, "z")

    atlasStyle.SetLabelSize(tsize, "x")
    atlasStyle.SetTitleSize(tsize, "x")
    atlasStyle.SetLabelSize(tsize, "y")
    atlasStyle.SetTitleSize(tsize, "y")
    atlasStyle.SetLabelSize(tsize, "z")
    atlasStyle.SetTitleSize(tsize, "z")

    # Use bold lines and markers
    atlasStyle.SetMarkerStyle(20)
    atlasStyle.SetMarkerSize(1.2)
    atlasStyle.SetHistLineWidth(2)
    atlasStyle.SetLineStyleString(2, "[12 12]") # postscript dashes

    # Get rid of error bar caps
    atlasStyle.SetEndErrorSize(0.)

    # Do not display any of the standard histogram decorations
    atlasStyle.SetOptTitle(0)
    atlasStyle.SetOptStat(0)
    atlasStyle.SetOptFit(0)

    # Put tick marks on top and RHS of plots
    atlasStyle.SetPadTickX(1)
    atlasStyle.SetPadTickY(1)

    # Remove legend borders and set font
    atlasStyle.SetLegendBorderSize(0)
    atlasStyle.SetLegendFillColor(0)
    atlasStyle.SetLegendFont(43)
    atlasStyle.SetLegendTextSize(tsize)

    return atlasStyle

def set_atlas_style(tsize: Optional[int] = None) -> None:
    """Sets the global ROOT plot style to the ATLAS Style.
    Parameters
    ----------
    tsize : float, optional
        Text size in pixels. The default is `None`, in which case it will use
        the default text size defined in `AtlasStyle()`.
    """
    print("\u001b[34;1mApplying ATLAS style settings\u001b[0m")

    if tsize is None:
        style = atlas_style()
    else:
        style = atlas_style(tsize)

    # Release ownership, otherwise lost when moved out of scope
    ROOT.SetOwnership(style, False)

    ROOT.gROOT.SetStyle("ATLAS")
    ROOT.gROOT.ForceStyle()

def ATLASlabel(
    x: float, 
    y: float, 
    text: Optional[str] = None, 
    textScale: float = 1.0,
    fontSize: Optional[float] = None
) -> ROOT.TLatex:
    l = ROOT.TLatex()
    l.SetTextAlign(11)
    if fontSize:
        l.SetTextSize(fontSize)
    text = '' if text is None else f' #scale[{textScale}]{{' + text + '}'
    return l.DrawLatexNDC(x, y, '#bf{#it{ATLAS}}' + text)
