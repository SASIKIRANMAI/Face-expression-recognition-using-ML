classdef CascadeObjectDetector < matlab.system.System 
    
    
    properties(Nontunable)
       
        ClassificationModel = 'FrontalFaceCART';
    end
    properties
                  
        MinSize;
        
        MaxSize;
        
        ScaleFactor = 1.1;
        
        MergeThreshold = 4;
    end

    properties (Transient,Access = private)        
        pCascadeClassifier;       
    end   
    
    properties (Access = private)
        
        pColorSpaceConverter = vision.ColorSpaceConverter(...
            'Conversion','RGB to intensity');
    end
    properties(Hidden,Dependent,SetAccess = private)
        
        TrainingSize;
    end    
    methods
        
        function obj = CascadeObjectDetector(varargin)              
            obj.pCascadeClassifier = vision.internal.CascadeClassifier;
            initialize(obj);
            setProperties(obj,nargin,varargin{:},'ClassificationModel');             
            validatePropertiesImpl(obj);
        end
        
        
        
        function set.ClassificationModel(obj,value)            
            validateattributes(value,{'char'},{'nonempty','row'});            
            if ~isKey(obj.ModelMap,value) ...
                    && ~(exist(value,'file') == 2)               
                error(message('vision:ObjectDetector:modelNotFound',value));
            end
            obj.ClassificationModel = value;               
            initialize(obj);
        end
        
        
        function set.ScaleFactor(obj,value) 
            validateattributes( value,{'numeric'},...
                {'scalar', '>',1,'real', 'nonempty','nonsparse','finite'},...
                '','ScaleFactor');
            
            obj.ScaleFactor = value;
        end
        
       
        function set.MinSize(obj,value)
            validateSize('MinSize',value);
            obj.MinSize = value;
        end
        
        
        function set.MaxSize(obj,value)            
            validateSize('MaxSize',value);
            obj.MaxSize = value;
        end
        
       
        function set.MergeThreshold(obj,value)           
            validateattributes( value, ...
                {'numeric'}, {'scalar','>=' 0, 'real','integer',...
                'nonempty','nonsparse','finite'},...
                '','MergeThreshold');
            
            obj.MergeThreshold = value;
        end  
        
        
        function value = get.TrainingSize(obj)
            info = obj.pCascadeClassifier.getClassifierInfo();
            value = info.originalWindowSize;
        end  
    end
    
    methods(Access = protected)        
        
        function validatePropertiesImpl(obj)

            
            if ~isempty(obj.MinSize)
                if any(obj.MinSize < obj.TrainingSize)
                    error(message('vision:ObjectDetector:minSizeLTTrainingSize',...
                        obj.TrainingSize(1),obj.TrainingSize(2)));
                end
            end
            
            
            if isempty(obj.MinSize) && ~isempty(obj.MaxSize)
                if any(obj.TrainingSize >= obj.MaxSize)
                    error(message('vision:ObjectDetector:modelMinSizeGTMaxSize',...
                        obj.TrainingSize(1),obj.TrainingSize(2)));
                end
            end
            
            
            if ~isempty(obj.MaxSize) && ~isempty(obj.MinSize)               
                if any(obj.MinSize >= obj.MaxSize)
                    error(message('vision:ObjectDetector:minSizeGTMaxSize'));
                end
            end
            
        end
                     
        
        function validateInputsImpl(~,I)            
            validateattributes(I,...
                {'uint8','uint16','double','single','int16'},...
                {'real','nonsparse'},...
                '','',2);
            if ~any(ndims(I)==[2 3])
                error(message('vision:dims:imageNot2DorRGB'));
            end
        end
        
        
        function bboxes = stepImpl(obj,I)
                    
             
            I = im2uint8(I);
            
           
            if ndims(I) == 3
                I = step(obj.pColorSpaceConverter,I);
            end 
            
            bboxes = double(obj.pCascadeClassifier.detectMultiScale(I, ...
                double(obj.ScaleFactor), ...
                uint32(obj.MergeThreshold), ...            
                int32(obj.MinSize), ...
                int32(obj.MaxSize)));
        end
                
        
        function releaseImpl(obj)
            release(obj.pColorSpaceConverter);
        end
        
        
        function loadObjectImpl(obj,s, ~)
            obj.ScaleFactor = s.ScaleFactor;
            obj.MinSize = s.MinSize;
            obj.MaxSize = s.MaxSize;
            obj.MergeThreshold = s.MergeThreshold;
            
            try 
                obj.ClassificationModel = s.ClassificationModel;
            catch ME %#ok<NASGU>

                warning(...
                    message('vision:ObjectDetector:modelNotFoundOnLoad',...
                    s.ClassificationModel,'FrontalFaceCART'));
            end            
        end
        
        
        function initialize(obj)                         
            obj.pCascadeClassifier.load(obj.getModelPath(obj.ClassificationModel));
        end
                
        
        function num_inputs = getNumInputsImpl(~)
            num_inputs = 1;
        end
        

        function num_outputs = getNumOutputsImpl(~)
            num_outputs = 1;
        end              
    end
    properties(Constant,Hidden)      

        ModelMap = makeModelMap();
    end
    methods(Static, Hidden)
      
        function file_path = getModelPath(name)
            if isdeployed
                rootDirectory = ctfroot;
            else
                rootDirectory = matlabroot;
            end
            dataDirectory = fullfile(rootDirectory,'toolbox','vision',...
            'visionutilities','classifierdata','cascade');
          
         
            if isKey(vision.CascadeObjectDetector.ModelMap,name)
                filename = vision.CascadeObjectDetector.ModelMap(name);
                if strncmp(filename,'lbp',3)
                    feature_type = 'lbp';
                else
                    feature_type = 'haar';
                end                
            
                file_path = fullfile(dataDirectory,feature_type,filename);
            else
                
                file_path = which(name);
                if isempty(file_path) 
                    file_path = name; 
                end
            end
        end
       
        function tf = generatesCode
            tf = false;
        end
    end
end 


function validateSize(prop,value)

validateattributes( value,...
    {'numeric'}, {'real','nonsparse','finite','2d','integer', '>=',0},...
    '',prop);

if ~isempty(value) && (numel(value) ~= 2)
    error(message('vision:ObjectDetector:invalidSize',prop));
end

end


function map = makeModelMap()


mapData = {...
    'FrontalFaceCART', 'haarcascade_frontalface_alt2.xml';...
    'FrontalFaceLBP',  'lbpcascade_frontalface.xml';...
    'ProfileFace',     'haarcascade_profileface.xml';...
    'Mouth',           'haarcascade_mcs_mouth.xml';...
    'Nose',            'haarcascade_mcs_nose.xml';...    
    'EyePairBig',      'haarcascade_mcs_eyepair_big.xml';...
    'EyePairSmall',    'haarcascade_mcs_eyepair_small.xml';...
    'RightEye',        'haarcascade_mcs_righteye.xml';...
    'LeftEye',         'haarcascade_mcs_lefteye.xml';...
    'RightEyeCART',    'haarcascade_righteye_2splits.xml';...
    'LeftEyeCART',     'haarcascade_lefteye_2splits.xml';...
    'UpperBody',       'haarcascade_mcs_upperbody.xml'};

map = containers.Map(mapData(:,1),mapData(:,2));

end
