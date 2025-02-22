unit strpas2jsdesign;

{$mode objfpc}{$H+}

interface

Resourcestring
  // "Create new" dialog
  pjsdWebApplication = 'Web Browser Application';
  pjsdWebAppDescription = 'A pas2js program running in the browser';
  pjsdNodeJSApplication = 'Node.js Application';
  pjsdNodeJSAppDescription = 'A pas2js program running in node.js';

  // menu item
  SPasJSWebserversCaption = 'Pas2JS WebServers';

  // Static texts webservers form
  SWebserversStatus  = 'Status';
  SWebserversPort    = 'Port';
  SWebserversBaseDir = 'Root directory';
  SWebserversProject = 'Project';
  SWebserversExtra   = 'Additional info';
  SWebserversCount   = 'Number of webserver processes: %s';
  SWebserversCaption = 'Web server processes';

  // Dynamic texts webservers form
  SStatusRunning = 'Running';
  SStatusStopped = 'Stopped';
  SStatusError   = 'Error starting';

  // IDE options frame
  pjsdSelectPas2jsExecutable = 'Select pas2js executable';
  pjsdSelectSimpleserverExecutable = 'Select simpleserver executable';
  pjsdSelectNodeJSExecutable = 'Select Node.js executable';
  pjsdSelectBrowserExecutable = 'Select browser executable';
  pjsdPathOf = 'Path of %s';
  pjsdYouCanUseIDEMacrosLikeMakeExeWithoutAFullPathIsSea = 'You can use IDE '
    +'macros like $MakeExe(). Without a full path, %s is searched in PATH.';
  pjsdBrowse = 'Browse';
  pjsdPortNumbersToStartAllocatingFrom = 'Port numbers to start allocating '
    +'from %s';
  pjsdServerInstancesWillBeStartedWithAPortStartingFromT = 'Server instances '
    +'will be started with a port starting from this number, increasing per '
    +'new project';
  pjsdBrowserToUseWhenOpeningHTMLPage = 'Browser to use when opening HTML page';
  pjsdUseThisBrowserWhenOpeningTheURLOrHTMLFileOfAWebBro = 'Use this browser '
    +'when opening the URL or HTML file of a web browser project';
  pjsdPathOfNodeJsExecutable = 'Path of Node.js executable';

  // Project options frame
  pjsdWebProjectPas2js = 'Web Project (pas2js)';
  pjsdProjectIsAWebBrowserPas2jsProject = 'Project is a Web Browser (pas2js) '
    +'project';
  pjsdProjectHTMLPage = 'Project HTML page:';
  pjsdMaintainHTMLPage = 'Maintain HTML page';
  pjsdUseBrowserConsoleUnitToDisplayWritelnOutput = 'Use Browser Console unit '
    +'to display writeln() output';
  pjsdRunRTLWhenAllPageResourcesAreFullyLoaded = 'Run RTL when all page '
    +'resources are fully loaded';
  pjsdProjectNeedsAHTTPServer = 'Project needs a HTTP server';
  pjsdStartHTTPServerOnPort = 'Start HTTP Server on port';
  pjsdUseThisURLToStartApplication = 'Use this URL to start application';
  pjsdResetRunCommand = 'Reset Run command';
  pjsdResetCompileCommand = 'Reset Compile command';

  // New browser project options form
  pjsdPas2JSBrowserProjectOptions = 'Pas2JS Browser project options';
  pjsdCreateInitialHTMLPage = 'Create initial HTML page';
  pjsdUseBrowserApplicationObject = 'Use Browser Application object';

  // New NodeJS project options form
  pjsdNodeJSProjectOptions = 'NodeJS project options';
  pjsdUseNodeJSApplicationObject = 'Use NodeJS Application object';

  // Macros names
  pjsdPas2JSExecutable = 'Pas2JS executable';
  pjsdPas2JSSelectedBrowserExecutable = 'Pas2JS selected browser executable';
  pjsdPas2JSSelectedNodeJSExcutable = 'Pas2JS selected NodeJS excutable';
  pjsdPas2JSCurrentProjectURL = 'Pas2JS current project URL';

  // Error descriptions
  pjsdMissingPathToPas2js = 'missing path to pas2js';
  pjsdFileNotFound = 'file "%s" not found';
  pjsdDirectoryNotFound = 'directory "%s" not found';
  pjsdFileNotExecutable = 'file "%s" not executable';
  pjsdFileNameDoesNotStartWithPas2js = 'filename does not start with "pas2js"';

implementation

end.

