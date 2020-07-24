Class {
	#name : #BPAssembledCode,
	#superclass : #Object,
	#instVars : [
		'instructions',
		'memoryLayout',
		'labels'
	],
	#pools : [
		'BPConstants'
	],
	#category : #'BytePusher-Assembler-Model'
}

{ #category : #adding }
BPAssembledCode >> addInstruction: anInstruction [
	self instructions add: anInstruction
]

{ #category : #labels }
BPAssembledCode >> addLabel: aBPLabel [ 
	labels add: aBPLabel
]

{ #category : #'as yet unclassified' }
BPAssembledCode >> bytesRequired [
	^ self instructions detectSum: #bytesRequired
]

{ #category : #accessing }
BPAssembledCode >> firstInstruction [
	"We first search for the instruction labelled with #_start.
	 If it exists, we return it.
	 If it does not exist, we return the first instruction.
	"
	"1 halt."
	^ self instructionForLabelNamed: #_start
		ifFound: #yourself
		ifNone: [ self instructions first ]
]

{ #category : #initialization }
BPAssembledCode >> initialize [
	super initialize.
	self instructions: OrderedCollection new.
	labels := OrderedCollection new
]

{ #category : #accessing }
BPAssembledCode >> instructionForLabelNamed: aSymbol ifFound: foundBlock ifNone: notFoundBlock [
	^ self instructions
		detect: [ :instruction | (self labelsFor: instruction) anySatisfy: [ :any | any label = aSymbol ] ]
		ifFound: foundBlock
		ifNone: notFoundBlock
]

{ #category : #accessing }
BPAssembledCode >> instructions [
	^ instructions
]

{ #category : #accessing }
BPAssembledCode >> instructions: anObject [
	instructions := anObject
]

{ #category : #accessing }
BPAssembledCode >> labelFor: anInstruction ifFound: foundBlock ifNone: notFoundBlock [
	^ self labels
		detect: [ :label | label address = anInstruction address ]
		ifFound: foundBlock
		ifNone: notFoundBlock
]

{ #category : #accessing }
BPAssembledCode >> labelNamed: aString [ 
	^ labels detect: [ :label | label label = aString ]
]

{ #category : #accessing }
BPAssembledCode >> labels [
	^ labels
]

{ #category : #accessing }
BPAssembledCode >> labelsFor: anInstruction [
	^ self labels select: [ :label | label address = anInstruction address ]
]

{ #category : #accessing }
BPAssembledCode >> memoryLayout [
	^ memoryLayout
]

{ #category : #accessing }
BPAssembledCode >> memoryLayout: anObject [
	memoryLayout := anObject
]

{ #category : #'serialize/materialize' }
BPAssembledCode >> serialize [
	^ (ByteArray new: MEMORY_SIZE) in: [ :memory |
		self serializeOn: memory.
		memory ]
]

{ #category : #'serialize/materialize' }
BPAssembledCode >> serializeOn: aByteArray [
	| initialProgramCounter |
	initialProgramCounter := self firstInstruction address.
	
	"We consider that any memory layout defines a program counter."
	(self memoryLayout reservedMemoryZoneNamed: #PROGRAM_COUNTER) address
		storeAddress: initialProgramCounter in: aByteArray.
	
	self memoryLayout
		initializeMemory: aByteArray.
	
	self instructions do: [ :instruction |
		instruction writeOn: aByteArray ]
]
