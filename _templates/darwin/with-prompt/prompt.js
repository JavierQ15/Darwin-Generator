
module.exports = {
  prompt: ({ inquirer }) => {
    // defining questions in arrays ensures all questions are asked before next prompt is executed
    const questions = [{
      type: 'input',
      name: 'moduleName',
      message: "What's your module name?"
    },
    {
      type: 'multiselect',
      name: 'componentsToGenerate',
      message: 'What elements do you want to generate?',
      choices: [
        'Router',
        'Controller',
        'Service',
      ],
      default:true
    }]

    return inquirer
      .prompt(questions)
      .then(answers => {
        const { moduleName } = answers
        const questions = []
        const parseController = (moduleName.charAt(0).toUpperCase() + moduleName.slice(1)).replace(/\s+/g, "");
        answers.moduleName = {
          name:moduleName,
          fUpperCase: parseController,
          str: parseController.split(/(?=[A-Z])/).join(' '),
          strLower: moduleName.split(/(?=[A-Z])/).join(' ').toLowerCase()
        }
        questions.push({
          type: 'input',
          name: 'strFunctionsName',
          message: "What are your functions names?",
          default: `get${parseController},create${parseController},update${parseController},delete${parseController}`
        })
        // both set of answers must be returned as a merged object, else the previous set of answers won't be available to the templates
        return inquirer.prompt(questions).then(nextAnswers => {
          const questions = []
          // these values can be retrieved in the template with: eval(field + '.validation')
          nextAnswers.functionsName = nextAnswers.strFunctionsName.replace(/\s+/g, "").split(',').map(fnName => {
            fnName = fnName.replace(/\s+/g,'');
            questions.push({
              type: 'multiselect',
              name: fnName+'_req',
              message: fnName+': What data do you want to read from the request?',
              choices: [
                'Body',
                'Query',
                'Params',
                'SecurityToken',
              ],
              default:true
            })
            const res = {};
            res.upperCase = fnName.toUpperCase();
            res.fUpperCase = fnName.charAt(0).toUpperCase() + fnName.slice(1);
            res.make = `make${res.fUpperCase}`;
            res.str = fnName.split(/(?=[A-Z])/).join(' ').toLowerCase();
            res.name = fnName;
            return res;
          });
          return inquirer.prompt(questions).then(nnAnswers => {
            nextAnswers.functionsName = nextAnswers.functionsName.map(fnName=>{
              const res = fnName;
              res.req = nnAnswers[fnName.name+'_req'];
              return res;
            })
            return Object.assign({},nextAnswers,answers);
          })
        })
      })
  },
}
