classdef Test_Moyamoya < TestCase
	%% TEST_MOYAMOYA 
	%  Usage:  >> runtests tests_dir 
	%          >> runtests mldb.Test_Moyamoya % in . or the matlab path
	%          >> runtests mldb.Test_Moyamoya:test_nameoffunc
	%          >> runtests(mldb.Test_Moyamoya, Test_Class2, Test_Class3, ...)
	%  See also:  package xunit

	%  $Revision: 2641 $
 	%  was created $Date: 2013-09-21 17:58:23 -0500 (Sat, 21 Sep 2013) $
 	%  by $Author: jjlee $, 
 	%  last modified $LastChangedDate: 2013-09-21 17:58:23 -0500 (Sat, 21 Sep 2013) $
 	%  and checked into repository $URL: file:///Users/jjlee/Library/SVNRepository_2012sep1/mpackages/mldb/test/+mldb_xunit/Test_Moyamoya.m $, 
 	%  developed on Matlab 8.0.0.783 (R2012b)
 	%  $Id: Test_Moyamoya.m 2641 2013-09-21 22:58:23Z jjlee $
 	%  N.B. classdef (Sealed, Hidden, InferiorClasses = {?class1,?class2}, ConstructOnLoad)

	properties (Dependent)
        moyamoyaObj
        sessionDir
        studyDir
        testId
        xlsx
        surffile
        surfvar
    end

    methods %% set/get
        function sd = get.sessionDir(this)
            dt = mlsystem.DirTool(fullfile(this.studyDir, [this.testId '*']));
            assert(1 == length(dt.fqdns));
            sd = fullfile(this.studyDir, dt.fqdns{1});
        end
        function sd = get.studyDir(this) %#ok<MANU>
            sd = fullfile(getenv('HOME'), 'MATLAB-Drive/mlfourd/test/np755', '');
        end
        function id = get.testId(this) %#ok<MANU>
            id = 'mm05-001_p7730';
        end
        function x  = get.xlsx(this) %#ok<MANU>
            x = fullfile(getenv('HOME'), 'MATLAB-Drive/mldb/test', 'excelTestsheet.xlsx');
        end
    end
    
	methods 
        function test_getCorticalThickness(this)
            assertEqual([1 1], this.moyamoyaObj.getCorticalThickness(this.testId))
        end
        function test_getOefRatio(this)
            assertVectorsAlmostEqual( ...
                [1.077770452 1.068375364], this.moyamoyaObj.getOefRatio(this.testId))
        end
 		function test_newIdentifier(this) 
 			import mldb.*; 
            assertEqual(this.testId, this.moyamoyaObj.newIdentifier('mm05-001', 'p7730'));
        end 
 		function this = Test_Moyamoya(varargin) 
 			this = this@TestCase(varargin{:}); 
            import mldb.*;
            this.moyamoyaObj = Moyamoya(this.studyDir);
            this.moyamoyaObj.oefContainer = Excel.readall(this.xlsx);
            this.moyamoyaObj.surferContainer = load(this.surffile, this.surfvar);
        end % ctor 
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

