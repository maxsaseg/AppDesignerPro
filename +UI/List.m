classdef List < handle
    %% Show List dialog in uifigure
    %   Allows to create list dialogs embedded in uifigures and apps
    %   Author: Max Sass Egebo
    %

    properties
        UIFigure      % Parent uifigure
        UIOverlay     % UI.Overlay object
        UIListbox     % Listbx UI object
        UILabels      % UI lables for fields
        Values        % uiinput values
        Title         % Overlay title
        InitialValue  % initially selected item
        Multiselect   % 'on' or 'off'
        Prompt        % List box prompt
        ListString    % List of items
        Transparent   % Transparent background
        Width         % uilistdlg width
        Height        % uilistdlg height
        OkText        % Text of the OK button
        CancelText    % Text of the Cancel button
        BtnWidth = 75 % Width of buttons
        Ok = false    % uiinput is applied
        Wait          % pause MATLAB after call
    end

    methods
        function obj = List(varargin)
            %% Constructor
            p = inputParser();
            p.addOptional('uifig', []);
            p.addParameter('ListString', {'Item1', 'Item2', 'Item3', 'Item4'}, @(x)ischar(x)||isstring(x)||iscellstr(x));
            p.addParameter('Multiselect', 'on', @(x)ischar(x)||isstring(x));
            p.addParameter('InitialValue', 1, @(x)validateattributes(x,{'numeric'},...
                                                  {'nonempty','integer','positive'}));
            p.addParameter('Title', '', @(x)ischar(x)||isstring(x));
            p.addParameter('Prompt', '',  @(x)ischar(x)||isstring(x)||iscellstr(x));
            p.addParameter('Width', 200);
            p.addParameter('Height', 300);
            p.addParameter('Transparent', false);
            p.addParameter('OkText', 'OK', @(x)ischar(x)||isstring(x));
            p.addParameter('CancelText', 'Cancel', @(x)ischar(x)||isstring(x));
            p.addParameter('Wait', true);
            p.addParameter('Show', true);
            p.parse(varargin{:});
            args = p.Results;
            if isempty(args.uifig)
                obj.UIFigure = uifigure;
            else
                obj.UIFigure = args.uifig;
            end
            obj.Title = args.Title;
            obj.Prompt = args.Prompt;
            obj.Width = args.Width;
            obj.Height = args.Height; % + 40;
            obj.ListString = args.ListString;
            obj.Multiselect = args.Multiselect;
            obj.InitialValue = args.InitialValue;
            obj.Transparent = args.Transparent;
            obj.OkText = args.OkText;
            obj.CancelText = args.CancelText;
            obj.ListString = args.ListString;
            obj.Wait = args.Wait;
            obj.redraw();
            if args.Show
                obj.show();
            end

        end

        function show(obj)
            %% Show input
            obj.UIOverlay.show();
            if obj.Wait
                uiwait(obj.UIFigure);
            end
        end

        function close(obj, varargin)
            %% Close input
            obj.UIOverlay.hide()
            uiresume(obj.UIFigure);
        end

        function apply(obj)
            %% Apply and close input
            obj.Values = get(obj.UIListbox, 'Value');
            obj.Ok = true;
            obj.close();
        end

        function redraw(obj)
            %% Redraw UI objects
            if ~isempty(obj.UIOverlay) && isvalid(obj.UIOverlay)
                delete(obj.UIOverlay);
            end
            if ~isempty(obj.Title)
                obj.Height = obj.Height + 20;
            end
            if obj.Transparent
                args = {'BackgroundColor', 'none'};
            else
                args = {};
            end
            obj.UIOverlay = UI.Overlay(obj.UIFigure, 'Width', obj.Width,...
                'Height', obj.Height, 'Show', false, 'Title', obj.Title, args{:});
            panel = obj.UIOverlay.UIPanel;
            refpos = [0 0 obj.Width obj.Height];
            obj.drawFields(panel);
            cbtn = uibutton(panel, 'Text', obj.CancelText, 'ButtonPushedFcn', @obj.close);
            cbtnpos = cbtn.Position;
            cbtnpos(3) = obj.BtnWidth;
            cbtn.Position = uialign(cbtnpos, refpos, 'right', 'bottom', true, [-7 7]);
            okbtn = uibutton(panel, 'Text', obj.OkText, 'ButtonPushedFcn', @(~,~)obj.apply());
            okbtnpos = okbtn.Position;
            okbtnpos(3) = obj.BtnWidth;
            okbtn.Position = uialign(okbtnpos, cbtn, 'right', 'same', false, [-(obj.BtnWidth+5) 0]);
        end

        function f = drawFields(obj, parent)
            %% Add field to input

            %TODO: properly place ui objects
            refpos = [0 0 obj.Width obj.Height];
            
            f = uilistbox(parent, 'Items', obj.ListString,...
                                  'ItemsData', 1:numel(obj.ListString),...
                                  'Value', obj.InitialValue,...
                                  'Multiselect', obj.Multiselect);
            inppos = f.Position;
            inppos(3) = refpos(3) - 14;
            f.Position = uialign(inppos, refpos, 'center', 'top', false, [0, -40]); %TODO: This is trial and error
            obj.UIListbox = f;
        end

        function delete(obj)
            %% Destructor
            delete(obj.UIOverlay);
        end

    end
end