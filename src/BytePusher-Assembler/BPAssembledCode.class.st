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

{ #category : #accessing }
BPAssembledCode >> firstInstruction [
	^ self instructions detect: #isInstruction
]

{ #category : #initialization }
BPAssembledCode >> initialize [
	super initialize.
	self instructions: OrderedCollection new.
	labels := OrderedCollection new
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
	PROGRAM_COUNTER_ADDRESS asBPAddress storeAddress: initialProgramCounter in: aByteArray.
	PIXEL_POINTER_ADDRESS asBPAddress store: (self memoryLayout reservedMemoryZoneNamed: #DISPLAY_FRAME) address higherByte in: aByteArray.
	AUDIO_POINTER_ADDRESS asBPAddress store: (self memoryLayout reservedMemoryZoneNamed: #AUDIO_SAMPLE) address higherByte in: aByteArray.
	AUDIO_POINTER_ADDRESS asBPAddress + 1 store: (self memoryLayout reservedMemoryZoneNamed: #AUDIO_SAMPLE) address middleByte in: aByteArray.
	BPAddPageBuilder writeBankOn: aByteArray.
	BPAddCarryFlagPageBuilder writeBankOn: aByteArray.
	BPAddZeroFlagPageBuilder writeBankOn: aByteArray.
	BPCmpPageBuilder writeBankOn: aByteArray.
	BPIdentityPageBuilder writeBankOn: aByteArray.
	BPBitAndPageBuilder writeBankOn: aByteArray.
	"Creat the infinite NOP loop."
	((self memoryLayout reservedMemoryZoneNamed: #INFINITE_NOP) startAddress + (2 * INSTRUCTION_SIZE))
		storeAddress: (self memoryLayout reservedMemoryZoneNamed: #INFINITE_NOP) startAddress in: aByteArray.
	
	self instructions do: [ :instruction |
		instruction writeOn: aByteArray ]
]
