classdef Test_Excel < TestCase
	%% TEST_EXCEL 
	%  Usage:  >> runtests tests_dir 
	%          >> runtests mldb.Test_Excel % in . or the matlab path
	%          >> runtests mldb.Test_Excel:test_nameoffunc
	%          >> runtests(mldb.Test_Excel, Test_Class2, Test_Class3, ...)
	%  See also:  package xunit

	%  $Revision: 2641 $
 	%  was created $Date: 2013-09-21 17:58:23 -0500 (Sat, 21 Sep 2013) $
 	%  by $Author: jjlee $, 
 	%  last modified $LastChangedDate: 2013-09-21 17:58:23 -0500 (Sat, 21 Sep 2013) $
 	%  and checked into repository $URL: file:///Users/jjlee/Library/SVNRepository_2012sep1/mpackages/mldb/test/+mldb_xunit/Test_Excel.m $, 
 	%  developed on Matlab 8.0.0.783 (R2012b)
 	%  $Id: Test_Excel.m 2641 2013-09-21 22:58:23Z jjlee $
 	%  N.B. classdef (Sealed, Hidden, InferiorClasses = {?class1,?class2}, ConstructOnLoad)

	properties
        excelObj
        testsheet
    end

    methods (Static)
        function dispRaw()
            this = mldb_xunit.Test_Excel('test_ctor');
            disp(this.excelObj.raw);
        end
    end
    
	methods
        function test_readall(this)
            assertEqual('Microsoft Macintosh Excel Spreadsheet', this.excelObj.kind);
            assertEqual('Sheet1', this.excelObj.sheets{1});
            assertEqual(nan, this.excelObj.num(1,1));
            assertEqual('Name', this.excelObj.txt{1,1});
            assertEqual('Name', this.excelObj.raw{1,1});
        end
        function test_ctor(this)
            assertTrue(~isempty(this.testsheet));
            assertTrue(~isempty(this.excelObj));
        end
 		function this = Test_Excel(varargin) 
 			this = this@TestCase(varargin{:});
            this.testsheet = fullfile(getenv('HOME'), 'MATLAB-Drive/mldb/test', 'excelTestsheet.xlsx');
            this.excelObj = mldb.Excel.readall(this.testsheet);
        end % ctor 
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

