classdef Moyamoya
	%% MOYAMOYA restructures categorized data & freesurfer data from study NP755
	%  $Revision: 2383 $
 	%  was created $Date: 2013-03-06 22:25:02 -0600 (Wed, 06 Mar 2013) $
 	%  by $Author: jjlee $, 
 	%  last modified $LastChangedDate: 2013-03-06 22:25:02 -0600 (Wed, 06 Mar 2013) $
 	%  and checked into repository $URL: file:///Users/jjlee/Library/SVNRepository_2012sep1/mpackages/mldb/src/+mldb/Moyamoya.m $, 
 	%  developed on Matlab 8.0.0.783 (R2012b)
 	%  $Id: Moyamoya.m 2383 2013-03-07 04:25:02Z jjlee $
 	%  N.B. classdef (Sealed, Hidden, InferiorClasses = {?class1,?class2}, ConstructOnLoad)

	properties
        studyDir
        oefContainer
        surferContainer
    end
    
    properties (Dependent)
        commonIds
    end

    methods (Static)
        function [mm,x,y] = maps2vecs(oefMap, ctMap, studyDir)
            assert(isa(oefMap, 'containers.Map'));
            assert(isa(ctMap, 'containers.Map'));
            if (~exist('studyDir', 'var'))
                [~,studyDir] = mlbash('echo $NP755'); end
            mm  = mldb.Moyamoya(studyDir);
            mm.oefContainer    = oefMap;
            mm.surferContainer = ctMap;
            [mm,x,y] = mm.maps2doubles(mm.oefContainer,  mm.surferContainer);
        end   
        function keys = intersectKeys(k1, k2)
            assert(iscell(k1));
            assert(iscell(k2));
            keys = {};
            for k = 1:length(k1)
                if (lstrfind(k2, k1{k}))
                    keys = [keys k1{k}]; end %#ok<AGROW>
            end
        end 
    end
    
    methods %% set/get
        function this = set.commonIds(this, id)
            id = ensureCell(id);
            for c = 1:length(id)
                this = this.addId(id{c});
            end
        end
        function ids  = get.commonIds(this)
            ids = this.commonIds_;
        end
    end
    
	methods 
        function [this,x,y] = maps2doubles(this, x, y)
            %% MAPS2DOUBLES receives containers.Map, returns double; restricts to common keys of x, y;
            
            assert(isa(x, 'containers.Map'));
            assert(isa(y, 'containers.Map'));
            this.commonIds = this.intersectKeys(x.keys, y.keys);
            x = this.map2double(x);
            y = this.map2double(y);
        end
        function ny   = map2double(this, y)
            assert(isa(y, 'containers.Map'));
            y  = values(y, this.commonIds);
            ny = cell2mat(y);
            ny = reshape(ny, 2*length(y), []);
        end
 		function this = Moyamoya(studydir) 
 			%% MOYAMOYA 
 			%  Usage:  obj = Moyamoya() 
            
            p = inputParser;
            addRequired(p, 'studydir', @(x) lexist(x,'dir'));
            parse(p, studydir);
            this.studyDir = p.Results.studydir;
            this.commonIds_ = {};
 		end %  ctor 
    end
    
    properties (Access = 'private')
        commonIds_
    end
    
    methods (Access = 'private')
        function this = addId(this, id)
            if (~lstrfind(this.commonIds_, id))
                this.commonIds_ = [this.commonIds_ id];
            end
        end
    end

    
	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

