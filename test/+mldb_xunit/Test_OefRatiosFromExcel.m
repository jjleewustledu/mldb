classdef Test_OefRatiosFromExcel < mldb.Excel
	%% TEST_OEFRATIOSFROMEXCEL 
	%  Usage:  >> runtests tests_dir 
	%          >> runtests mldb.Test_OefRatiosFromExcel % in . or the matlab path
	%          >> runtests mldb.Test_OefRatiosFromExcel:test_nameoffunc
	%          >> runtests(mldb.Test_OefRatiosFromExcel, Test_Class2, Test_Class3, ...)
	%  See also:  package xunit

	%  $Revision: 2384 $
 	%  was created $Date: 2013-03-06 22:25:43 -0600 (Wed, 06 Mar 2013) $
 	%  by $Author: jjlee $, 
 	%  last modified $LastChangedDate: 2013-03-06 22:25:43 -0600 (Wed, 06 Mar 2013) $
 	%  and checked into repository $URL: file:///Users/jjlee/Library/SVNRepository_2012sep1/mpackages/mldb/test/+mldb_xunit/Test_OefRatiosFromExcel.m $, 
 	%  developed on Matlab 8.0.0.783 (R2012b)
 	%  $Id: Test_OefRatiosFromExcel.m 2384 2013-03-07 04:25:43Z jjlee $
 	%  N.B. classdef (Sealed, Hidden, InferiorClasses = {?class1,?class2}, ConstructOnLoad)

	properties
 		% N.B. (Abstract, Access=private, GetAccess=protected, SetAccess=protected, Constant, Dependent, Hidden, Transient)
 	end

	methods 
 		% N.B. (Static, Abstract, Access='', Hidden, Sealed) 

 		function test_afun(this) 
 			import mldb.*; 
 		end 
 		function this = Test_OefRatiosFromExcel(varargin) 
 			this = this@mldb.Excel(varargin{:}); 
 		end% ctor 
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

