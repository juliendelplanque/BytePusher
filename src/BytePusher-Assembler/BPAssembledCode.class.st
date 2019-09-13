Class {
	#name : #BPAssembledCode,
	#superclass : #Object,
	#instVars : [
		'instructions',
		'memoryLayout'
	],
	#pools : [
		'BPConstants'
	],
	#category : #'BytePusher-Assembler'
}

{ #category : #adding }
BPAssembledCode >> addInstruction: anInstruction [
	self instructions add: anInstruction
]

{ #category : #accessing }
BPAssembledCode >> firstInstruction [
	^ self instructions detect: #isInstruction
]

{ #category : #initialization }
BPAssembledCode >> initialize [
	super initialize.
	self instructions: OrderedCollection new.
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
	self instructions do: [ :instruction |
		instruction writeOn: aByteArray ]
]
