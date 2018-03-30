classdef Excel
	%% EXCEL reads and writes Excel spreadsheets
	%  $Revision: 2383 $
 	%  was created $Date: 2013-03-06 22:25:02 -0600 (Wed, 06 Mar 2013) $
 	%  by $Author: jjlee $, 
 	%  last modified $LastChangedDate: 2013-03-06 22:25:02 -0600 (Wed, 06 Mar 2013) $
 	%  and checked into repository $URL: file:///Users/jjlee/Library/SVNRepository_2012sep1/mpackages/mldb/src/+mldb/Excel.m $, 
 	%  developed on Matlab 8.0.0.783 (R2012b)
 	%  $Id: Excel.m 2383 2013-03-07 04:25:02Z jjlee $
 	%  N.B. classdef (Sealed, Hidden, InferiorClasses = {?class1,?class2}, ConstructOnLoad)

	properties
        kind
        sheets
        num
        txt
        raw
    end

	methods (Static)
        function this = readall(xlsx)
            this = mldb.Excel;
            this = this.checkinfo(xlsx);
            this = this.read(xlsx);
        end
    end
    
    methods (Access = 'protected')
 		function this = Excel 
 		end %  ctor 
    end 
    
    methods (Access = 'private')
        function this = checkinfo(this, xlsx)
            try
                [this.kind,this.sheets] = xlsfinfo(xlsx);
                assertCharNotEmpty(this.kind);
                for s = 1:length(this.sheets)
                    assertCharNotEmpty(this.sheets{s});
                end
            catch ME
                handexcept(ME, 'Excel.checkinfo');
            end
        end
        function this = read(this, xlsx, varargin)
            try
                [this.num, this.txt, this.raw] = xlsread(xlsx, varargin{:});
            catch ME
                handexcept(ME, 'Excel.read');
            end
        end
    end
	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

