using '../../webapp/main.bicep'

param specification = {
  spaceName: 'dev'
  workload: 'todolist'
  size: 'S'

  useSql: true
  databases: [
    {
      name: 'todolist'
    }
  ]
}
