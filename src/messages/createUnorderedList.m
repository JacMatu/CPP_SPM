function list = createUnorderedList(list)
  %
  % turns a cell string or a structure into a string
  % that is an unordered list to print to the screen
  %
  % USAGE::
  %
  %  list = createUnorderedList(list)
  %
  % :param list: obligatory argument.
  % :type list: cell string or structure
  %
  %
  % (C) Copyright 2021 CPP_SPM developers

  prefix = '\n\t- ';

  if ischar(list)
    list = cellstr(list);
  end

  if iscell(list)
    list = sprintf([prefix, strjoin(list, prefix), '\n']);

  elseif isstruct(list)
    output = [];
    fields = fieldnames(list);
    for i = 1:numel(fields)
      content = list.(fields{i});
      if ~iscell(content)
        content = {content};
      end
      output = [output prefix fields{i} ': {' strjoin(content, ', ') '}'];
    end
    list = sprintf(output);
  end
end
