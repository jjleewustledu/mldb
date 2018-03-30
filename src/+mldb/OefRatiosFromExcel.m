classdef OefRatiosFromExcel < mldb.Excel
	%% OEFRATIOSFROMEXCEL ...
	%  $Revision: 2604 $
 	%  was created $Date: 2013-09-07 19:13:14 -0500 (Sat, 07 Sep 2013) $
 	%  by $Author: jjlee $, 
 	%  last modified $LastChangedDate: 2013-09-07 19:13:14 -0500 (Sat, 07 Sep 2013) $
 	%  and checked into repository $URL: file:///Users/jjlee/Library/SVNRepository_2012sep1/mpackages/mldb/src/+mldb/OefRatiosFromExcel.m $, 
 	%  developed on Matlab 8.0.0.783 (R2012b)
 	%  $Id: OefRatiosFromExcel.m 2604 2013-09-08 00:13:14Z jjlee $
 	%  N.B. classdef (Sealed, Hidden, InferiorClasses = {?class1,?class2}, ConstructOnLoad)

	properties 
        oefContainer
        xlsxFile = '/Volumes/PassportStudio/cvl/np755_extra/doc/np755 Moyamoya Categorized data JJL.xlsx';
    end
    
    properties (Dependent) 
        xlsx % lazy
    end

    methods (Static) 
        function m = createMapFromPattern(patt)
            this = mldb.OefRatiosFromExcel;
            dt = mlsystem.DirTool(patt);
            m = this.mapper(dt.fqdns);
        end
        function pid = findPid(lbl)
            %% FINDPID returns char
            
            [~,lbl] = fileparts(lbl);
            assert(strcmp('mm', lbl(1:2)));
            pid = lbl(1:8);
        end
        function pnum = findPnum(lbl)
            %% FINDPNUM returns double
            
            [~,lbl] = fileparts(lbl);
            idx = strfind(lbl, '_p'); 
            idx = idx + 2;
            if (1 ~= length(idx))
                error('mldb:unsupportedInputParam', 'Moyamoya.findPnum.lbl->%s', lbl); end
            pnum = str2double(lbl(idx:idx+3));
        end
        function pid = zeroPid(lbl)
            %% ZEROPID is the patient-id starting with the site-number, 01, 02, 06, ...
            
            pid = mldb.OefRatiosFromExcel.findPid(lbl);
            if (strcmp('mm', pid(1:2)))
                pid = pid(3:end); end
        end
    end
    
	methods %% set/get
        function x = get.xlsx(this)
            if (isempty(this.xlsx_))
                this.xlsx_ = this.fillinHemispheres(mldb.Excel.readall(this.xlsxFile));
            end
            x = this.xlsx_;
        end
    end
    
    methods
        function amap = mapper(this, ids)
            %% MAPPER returns a containers.Map with L/R values for the function handle
            
            amap = containers.Map;
            ids  = ensureCell(ids);
            for d = 1:length(ids)
                id = mlsurfer.SubjectId.subjectsDir2Id(ids{d});
                try
                    if (this.hemodynImpairment(id))
                        amap(id) = this.getOefRatios(id); end
                catch ME
                    handwarning(ME);
                end
            end 
        end
        function oefs = getOefRatios(this, id)
            %% GETOEFRATIOS returns the L/R pair of MCA OEFs normalized by the mean cerebellar values
            
            assert(ischar(id));
            oefs = this.lookupXlsxOefs( ...
                this.findPid(id), this.findPnum(id));
        end
        function oefs = lookupXlsxOefs(this, pid, pnum)
            %% LOOKUPXLSXOEFS returns the L/R pair of MCA OEFs, 2-vector, normalized by the mean cerebellar values
            
            rows   = this.scanPids(3, this.zeroPid(pid)); % col 3, selected row-pair
            record = this.scanPnums(rows, pnum, [8 11]); 
            oefs   = this.scanOefRatios(record);
        end
 		function this = OefRatiosFromExcel(varargin) 
 			%% OEFRATIOSFROMEXCEL 
 			%  Usage:  obj = OefRatiosFromExcel() 
            
            if (nargin > 0)
                this.xlsxFile = varargin{:}; end
 		end %  ctor 
    end 
    
    properties (Access = 'private')
        xlsx_
    end
    
    methods (Access = 'private') 
        function ex = fillinHemispheres(~, ex)
            for row = 2:length(ex.raw):2
                for col = 1:size(ex.raw,2)
                    if (notEmptyNextEmpty(ex.raw{row,col}, ex.raw{row+1,col}))
                        ex.raw{row,col} = ex.raw{row+1,col};
                    end
                end
            end
            function tf = notEmptyNextEmpty(curr, next)
                tf = ~(any(isnan(curr)) || isempty(curr)) && ...
                      (any(isnan(next)) || isempty(next));
            end
        end
        function rec  = scanPnums(this, rows, pnum, rng)
            %% SCANPNUMS rng:  2-vector for indices [start end]
            
            idx = this.indexOfLabel(rows(1,:), pnum);
            rec = rows(:,idx+rng(1):idx+rng(2));
        end
        function oefs = scanOefRatios(~, rec)
            %% SCANOEFRATIOS oefs:  2-row-vector for L, R oef-ratios
            
            oefs = cell2mat(rec(:,4)');
        end
        function rows = scanPids(this, col, lbl)
            idx = this.indexOfLabel(this.xlsx.raw(:,col)', lbl);
            rows = this.xlsx.raw(idx:idx+1,:);
        end
        function tf = hemodynImpairment(this, lbl)
            idx = this.indexOfLabel(this.xlsx.raw(:,3)', ...
                mldb.OefRatiosFromExcel.zeroPid(lbl));
            tf = lstrfind(this.xlsx.raw(idx,4)', '-');
        end
        function idx = indexOfLabel(this, raw, lbl)
            lbl = this.ensureString(lbl);
            idx = this.firstNonemptyCell( ...
                strfind( ...
                this.ensureString(raw), lbl));
            assert(1 == length(idx));
        end
        function ca = ensureString(this, ca)
            if (iscell(ca))
                for c = 1:length(ca)
                    ca{c} = this.ensureString(ca{c});
                end
                return
            end
            if (isnan(ca))
                ca = 'nan'; end
            if (isnumeric(ca))
                ca = num2str(ca); end
        end
        function idx = firstNonemptyCell(~, ca)
            for c = 1:length(ca)
                if (~isempty(ca{c}))
                    idx = c; return; end
            end
            error('mldb:dataNotFound', 'OefRatiosFromExcel.firstNonemptyCell');
        end
    end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

