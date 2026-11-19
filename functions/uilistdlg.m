function varargout = uilistdlg(varargin)
%Show in uifigure list dialog 
%   Allows to create list dialogs embedded in uifigures and apps
%
%   inp = UILISTDLG(uifig)
%   inp = UILISTDLG(uifig, label)
%   inp = UILISTDLG(uifig, labels, values)
%   inp = UILISTDLG(__, Name, Value)
%   h = UILISTDLG(__, 'Show', false)
%
%   Inputs:
%   uifig: uifigure object or another parent UI container
%
%   Name-value parameters:
%   'ListString': char | cellstr | string List of items to present in the dialog box
%   'Multiselect': string; can be 'on' or 'off'; defaults to
%                   'on'.
%   'InitialValue': vector of indices of which items of the list box
%                   are initially selected; defaults to the first item.
%   'Title': char | string - title of input dialog (default: '')
%   'Width': double - with of input dialog (default: 200)
%   'Transparent': logical - background transparency (default: false)
%   'OkText': char | string - Text of the OK button (default: 'OK')
%   'CancelText': char | string - Text of the Cancel button (default: 'Cancel')
%   'Wait': logical - pause execution while input dialog is opened (default: true)
%   'Show': logical - open input dialog immediately (default: true)
%
%   Outputs:
%   inp: cell | char | logical - uilistdlg values returns the index og selected item.
%   h: List - UI.List object
%
%   Example 1:
%       i = uilistdlg(uifigure, {'Enter text' 'Check'}, {'' false}, 'Width', 300);
%   Example 2:
%       h = uilistdlg(uifigure, 'Enter', '', 'Show', false)
%       h.Transparent = true;
%       h.CancelText = 'Close';
%       h.redraw
%       h.show
%
%   Example app: uilistdlgExample
%
%   Author: Max Sass Egebo

showi = cellfun(@(x) (isstring(x)||ischar(x))&&strcmp(x, 'Show'), varargin);
showi = find(showi);
i = UI.List(varargin{:});
if ~isempty(showi) && ~varargin{showi + 1}
    varargout = {i};
else
    varargout = {i.Values i.Ok};
end