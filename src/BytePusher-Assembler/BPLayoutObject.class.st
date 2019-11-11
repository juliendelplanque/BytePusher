"
I am an abstract object modelling the layout of BytePusher's memory.

My subclasses implement concrete objects relative to memory layout such as a register or a reserved memory zone.

A layout object has a name stored in my #name instance variable.

My concrete subclasses should implement
- #startAddress - Returning the start address (included) of the object in the memory.
- #endAddress - Returning the last address (included) of the object in the memory.
- #typeName - Returning a string containing the name of the type to be displayed to a human.
"
Class {
	#name : #BPLayoutObject,
	#superclass : #Object,
	#instVars : [
		'name'
	],
	#category : #'BytePusher-Assembler-Memory'
}

{ #category : #accessing }
BPLayoutObject >> addressesInterval [
	^ self startAddress to: self endAddress
]

{ #category : #accessing }
BPLayoutObject >> endAddress [
	"Returns the end address (included) of the object in the memory.
	 The returned address must be a BPAddress instance.
	"
	^ self subclassResponsibility
]

{ #category : #testing }
BPLayoutObject >> isRegister [
	^ false
]

{ #category : #testing }
BPLayoutObject >> isReservedMemoryZone [
	^ false
]

{ #category : #accessing }
BPLayoutObject >> name [
	^ name
]

{ #category : #accessing }
BPLayoutObject >> name: anObject [
	name := anObject
]

{ #category : #printing }
BPLayoutObject >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(.
	self name printOn: aStream.
	aStream nextPut: $)
]

{ #category : #accessing }
BPLayoutObject >> startAddress [
	"Returns the start address (included) of the object in the memory.
	 The returned address must be a BPAddress instance.
	"
	^ self subclassResponsibility
]

{ #category : #accessing }
BPLayoutObject >> typeName [
	^ self subclassResponsibility
]
