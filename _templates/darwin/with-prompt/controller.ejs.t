---
to: "<%= componentsToGenerate.includes('Controller') ?('src/controllers/'+moduleName.name+'/index.ts') : null %>"
---
import { NextFunction } from 'express';
import { techLog } from '@darwin-node/logger';
import { handleErrorResponse, handleGenericDataResponse } from '../../helpers/controller.helper';

////////////////////////////////////////////////////////////////////////////////
// CONSTANTS
////////////////////////////////////////////////////////////////////////////////

const MODULE_NAME = '[<%= moduleName.str %> Controller]';

////////////////////////////////////////////////////////////////////////////////
// PUBLIC FUNCTIONS
////////////////////////////////////////////////////////////////////////////////
<% functionsName.forEach(function(fnName) { %>
/**
* Generates <%= fnName.str %> function controller
* @param {Function} <%= fnName.name %>Service
* @returns {Function}
*/
const <%= fnName.make %> = (<%= fnName.name %>Service: Function): any => {
  /**
   * It <%= fnName.str %>.
   * @param {Object} req http request
   * @param {Object} res http response
   * @param {Function} next next middleware
   * @returns
   */
  return async function <%= fnName.name %>(req: any, res: any, next: NextFunction) {
    try {
      techLog.info(`${MODULE_NAME} ${<%= fnName.name %>.name} (IN)`);
      <%if (fnName.req.length > 0) { %>
      const params: any = {};
      <% } 
      %><%
      if (fnName.req.length > 0) {fnName.req.forEach(req => {
        %><%if (req === 'SecurityToken') { %>params.securityToken = req.get('securityToken');
      <% } else {%>params.<%= req.toLowerCase() %> = req.<%= req.toLowerCase() %>;
      <%} %><%
      }) } 
      %><%
      if (fnName.req.length > 0) { 
      %>
      techLog.info(`${MODULE_NAME} ${<%= fnName.name %>.name} (PARAMS) ${JSON.stringify(params)}`);
      <%
      } 
      %>
      <%= fnName.name %>Service(<%if (fnName.req.length > 0) { %>params<% } %>)
        .then((result: any) => {
          handleGenericDataResponse(MODULE_NAME, <%= fnName.name %>.name, result, res);
        })
        .catch((error: any) => {
          handleErrorResponse(MODULE_NAME, <%= fnName.name %>.name, error, res);
        });
    } catch (e) {
      next(e);
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



