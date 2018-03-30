classdef CorticalThickness
	%% CORTICALTHICKNESS retrieves cortical-thickness data from the filesystem
	%  $Revision: 2604 $
 	%  was created $Date: 2013-09-07 19:13:14 -0500 (Sat, 07 Sep 2013) $
 	%  by $Author: jjlee $, 
 	%  last modified $LastChangedDate: 2013-09-07 19:13:14 -0500 (Sat, 07 Sep 2013) $
 	%  and checked into repository $URL: file:///Users/jjlee/Library/SVNRepository_2012sep1/mpackages/mldb/src/+mldb/CorticalThickness.m $, 
 	%  developed on Matlab 8.0.0.783 (R2012b)
 	%  $Id: CorticalThickness.m 2604 2013-09-08 00:13:14Z jjlee $
 	%  N.B. classdef (Sealed, Hidden, InferiorClasses = {?class1,?class2}, ConstructOnLoad)

	properties
        studyDir
        oefContainer
    end
    
    methods (Static)
        function m = createMapFromPattern(patt)
            this = mldb.CorticalThickness;
            dt = mlsystem.DirTool(patt);
            m = this.mapper(dt.fqdns);
        end
    end

	methods 
        function amap = mapper(this, ids)
            %% MAPPERFUN returns a containers.Map with L/R values for the function handle
            
            amap = containers.Map;
            ids  = ensureCell(ids);
            for d = 1:length(ids)
                try
                    id = mlsurfer.SubjectId.subjectsDir2Id(ids{d});
                    amap(id) = this.getCorticalThickness(ids{d}, id);
                catch ME
                    handwarning(ME);
                end
            end 
        end
        function cts  = getCorticalThickness(~, subjsdir, subjid)
            %% GETCORTICALTHICKNESS returns L/R pair as 2-vector
            cd(subjsdir);
            cts = mlsurfer.EarlySurferData.processMcaThickAvg(subjsdir, subjid);
        end 
        
 		function this = CorticalThickness 
 			%% CORTICALTHICKNESS 
 			%  Usage:  obj = CorticalThickness() 

 		end %  ctor 
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

