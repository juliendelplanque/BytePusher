Class {
	#name : #BPAbstractAssembler,
	#superclass : #Object,
	#instVars : [
		'memoryLayout',
		'instructions'
	],
	#category : #'BytePusher-Assembler-Assembler'
}

{ #category : #accessing }
BPAbstractAssembler class >> defaultMemoryLayout [
	^ self subclassResponsibility
]

{ #category : #visiting }
BPAbstractAssembler >> acceptVisitor: aBPAssemblerVisitor [
	<generated>
	^ aBPAssemblerVisitor visitBPAssembler: self
]

{ #category : #adding }
BPAbstractAssembler >> addInstruction: anInstructionToResolve [
	self instructions add: anInstructionToResolve
]

{ #category : #assembling }
BPAbstractAssembler >> assemble [
	self setAddresses.
	self resolveNextInstructionReferences.
	self setLabelAddresses.
	self processAddressDataReference.
	^ self resolve
]

{ #category : #accessing }
BPAbstractAssembler >> defaultMemoryLayout [
	^ self class defaultMemoryLayout
]

{ #category : #including }
BPAbstractAssembler >> include: aLibrary [
	aLibrary beIncludedTo: self
]

{ #category : #initialization }
BPAbstractAssembler >> initialize [
	super initialize.
	self memoryLayout: self defaultMemoryLayout.
	self instructions: OrderedCollection new.
]

{ #category : #accessing }
BPAbstractAssembler >> instructions [
	^ instructions
]

{ #category : #accessing }
BPAbstractAssembler >> instructions: anObject [
	instructions := anObject
]

{ #category : #labelling }
BPAbstractAssembler >> label: aSymbol [
	self addInstruction: (BPLabel label: aSymbol)
]

{ #category : #accessing }
BPAbstractAssembler >> memoryLayout [
	^ memoryLayout
]

{ #category : #accessing }
BPAbstractAssembler >> memoryLayout: anObject [
	memoryLayout := anObject
]

{ #category : #assembling }
BPAbstractAssembler >> processAddressDataReference [
	BPProcessAddressDataReference visit: self
]

{ #category : #accessing }
BPAbstractAssembler >> registerNamed: aSymbol [
	^ self memoryLayout registerNamed: aSymbol
]

{ #category : #accessing }
BPAbstractAssembler >> reservedMemoryZoneNamed: aSymbol [
	^ self memoryLayout reservedMemoryZoneNamed: aSymbol
]

{ #category : #assembling }
BPAbstractAssembler >> resolve [
	^ BPReferencesResolver visit: self
]

{ #category : #assembling }
BPAbstractAssembler >> resolveNextInstructionReferences [
	BPNextInstructionReferenceResolver visit: self
]

{ #category : #assembling }
BPAbstractAssembler >> setAddresses [
	BPAddressesSetter visit: self
]

{ #category : #assembling }
BPAbstractAssembler >> setLabelAddresses [
	BPLabelAddressesSetter visit: self
]
