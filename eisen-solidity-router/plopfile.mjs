export default function (
  /** @type {import('plop').NodePlopAPI} */
  plop,
) {
  plop.setGenerator('facet', {
    description: 'Generates boilerplate for a new facet contract.',
    prompts: [
      {
        type: 'input',
        name: 'name',
        message: 'Give this facet a name:',
      },
      {
        type: 'input',
        name: 'description',
        message: 'Describe what this facet does:',
      },
    ], // array of inquirer prompts
    actions: [
      {
        type: 'add',
        path: 'contracts/Facets/{{properCase name}}Facet.sol',
        templateFile: 'templates/facet.template.hbs',
      },
    ], // array of actions
  })
}
