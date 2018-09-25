function figsize(x,y,unit)
%FIGSIZE size of a figure
%
%   Usage: figsize(x,y,unit)
%
%   Input parameters:
%       x,y         - x,y size of the figure
%       unit        - unit in which the size is given, can be one of the
%                     following: 'cm', 'px'
%
%   FIGSIZE(x,y,unit) sets the size of the last figure to x,y in the given unit.
%
%   See also: plot_sound_field

%*****************************************************************************
% The MIT License (MIT)                                                      *
%                                                                            *
% Copyright (c) 2010-2018 SFS Toolbox Developers                             *
%                                                                            *
% Permission is hereby granted,  free of charge,  to any person  obtaining a *
% copy of this software and associated documentation files (the "Software"), *
% to deal in the Software without  restriction, including without limitation *
% the rights  to use, copy, modify, merge,  publish, distribute, sublicense, *
% and/or  sell copies of  the Software,  and to permit  persons to whom  the *
% Software is furnished to do so, subject to the following conditions:       *
%                                                                            *
% The above copyright notice and this permission notice shall be included in *
% all copies or substantial portions of the Software.                        *
%                                                                            *
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR *
% IMPLIED, INCLUDING BUT  NOT LIMITED TO THE  WARRANTIES OF MERCHANTABILITY, *
% FITNESS  FOR A PARTICULAR  PURPOSE AND  NONINFRINGEMENT. IN NO EVENT SHALL *
% THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER *
% LIABILITY, WHETHER  IN AN  ACTION OF CONTRACT, TORT  OR OTHERWISE, ARISING *
% FROM,  OUT OF  OR IN  CONNECTION  WITH THE  SOFTWARE OR  THE USE  OR OTHER *
% DEALINGS IN THE SOFTWARE.                                                  *
%                                                                            *
% The SFS Toolbox  allows to simulate and  investigate sound field synthesis *
% methods like wave field synthesis or higher order ambisonics.              *
%                                                                            *
% http://sfstoolbox.org                                 sfstoolbox@gmail.com *
%*****************************************************************************


%% ===== Checking of input parameter =====================================
nargmin = 0;
nargmax = 3;
narginchk(nargmin,nargmax);
if nargin==0
    x = 10;
    y = 10;
    unit = 'cm';
end
isargpositivescalar(x,y)
isargchar(unit)


%% ===== Main ============================================================
% Convert to centimeters
if strcmp('px',unit) || strcmp('pixel',unit)
    x = px2cm(x);
    y = px2cm(y);
elseif strcmp('inches',unit)
    x = in2cm(x);
    y = in2cm(y);
end

% Adjust the font size to match the figure size
%set_font_size(12);

% Set the figure dimensions
set(gcf,'PaperUnits','centimeters');
set(gcf,'PaperSize',[y,x]);
set(gcf,'PaperPosition',[0,0,x,y]);