---
to: "<%= componentsToGenerate.includes('Service') ?('src/services/'+moduleName.name+'/index.ts') : null %>"
---
import { techLog } from '@darwin-node/logger';
import { getAppConfig } from '../../helpers/app.properties';

////////////////////////////////////////////////////////////////////////////////
// CONSTANTS
////////////////////////////////////////////////////////////////////////////////

const MODULE_NAME = '[<%= moduleName.str %> Service]';

////////////////////////////////////////////////////////////////////////////////
// PRIVATE FUNCTIONS
////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////
// PUBLIC FUNCTIONS
////////////////////////////////////////////////////////////////////////////////
<% functionsName.forEach(function(fnName) { %>
/**
* Generates <%= fnName.str %> function service
* @param {Function} <%= fnName.name %>Service
* @returns {Function}
*/
const <%= fnName.make %> = (): Function => {
  /**
   * It <%= fnName.str %>.
   * @returns {Object} any.
   */
  return async function <%= fnName.name %>(<%if (fnName.req.length > 0) { %>params: any<% } %>): Promise<any> {
    try {
      techLog.debug(`${MODULE_NAME} ${<%= fnName.name %>.name} (IN)<%if (fnName.req.length > 0) { %> -> ${JSON.stringify(params)}<% } %>`);
      // Your code here!
      <%if (fnName.req.length > 0) { %>const result = params;<% } else {%>const result = {};<%} %>
      techLog.debug(`${MODULE_NAME} ${<%= fnName.name %>.name} (OUT) -> ${JSON.stringify(result)}`);
      return result;
    } catch (e) {
      throw e;
    }
  };
};
<% }); %>
/**
 * @returns module functions.
 */
export { 
<% functionsName.forEach(function(fnName) { %>  <%= fnName.make %>,
<% }); %>};



