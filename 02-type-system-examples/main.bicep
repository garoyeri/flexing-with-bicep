// Examples from: https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/user-defined-data-types

// Bicep data type reference
type myStringType = string

// user-defined type reference
type myOtherStringType = myStringType

// a string type with three allowed values.
type myStringLiteralType = 'bicep' | 'arm' | 'azure'

// an integer type with one allowed value
type myIntLiteralType = 10

// an boolean type with one allowed value
type myBoolLiteralType = true

// A string type array
type myStrStringsType1 = string[]
// A string type array with three allowed values
type myStrStringsType2 = ('a' | 'b' | 'c')[]

type myIntArrayOfArraysType = int[][]

// A mixed-type array with four allowed values
type myMixedTypeArrayType = ('fizz' | 42 | {an: 'object'} | null)[]


// Object types contain zero or more properties between curly brackets
type storageAccountConfigType = {
  name: string
  sku: string
}

type storageAccountConfigTypeOptional = {
  name: string
  // this one is optional
  sku: string?
}

/*
  Unions can include any number of literal-typed expressions.
  Union types are translated into the allowed-value constraint in Bicep,
  so only literals are permitted as members.
*/
type oneOfSeveralObjects = {foo: 'bar'} | {fizz: 'buzz'} | {snap: 'crackle'}
type mixedTypeArray = ('fizz' | 42 | {an: 'object'} | null)[]

