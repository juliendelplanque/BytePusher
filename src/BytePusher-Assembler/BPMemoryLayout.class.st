"
I model the whole layout of BytePusher VM memory.
I am a composite object containing registers and reserved memory zones.
My purpose is to describe to the assembler how the memory is organized allowing it to know how to generate the bytecode.

My #startAddress and #endAddress are defined by BytePusher specifications.

I provide a nice API to manipulate my registers and reserved memory zones.

I also ensure that the memory layout built by my client is consistent (none of my layout objects overlap in the memory).

For an example of memory layout, check my class-side method #standard.
"
Class {
	#name : #BPMemoryLayout,
	#superclass : #BPLayoutObject,
	#instVars : [
		'layoutObjects'
	],
	#pools : [
		'BPConstants'
	],
	#category : #'BytePusher-Assembler-Memory'
}

{ #category : #factory }
BPMemoryLayout class >> standard [
	^ self new
		name: 'Standard';
		addAll: {
		BPRegister name: #KEYBOARD_HIGH address: KEYBOARD_STATE_ADDRESS.
		BPRegister name: #KEYBOARD_LOW address: KEYBOARD_STATE_ADDRESS + 1.
		BPReservedMemoryZone name: #PROGRAM_COUNTER startAddress: PROGRAM_COUNTER_ADDRESS size: ADDRESS_SIZE.
		BPReservedMemoryZone name: #DISPLAY_FRAME_POINTER startAddress: PIXEL_POINTER_ADDRESS size: 1.
		BPReservedMemoryZone name: #AUDIO_SAMPLE_POINTER startAddress: AUDIO_POINTER_ADDRESS size: 2.
		BPRegister name: #A address: USER_MEMORY_ADDRESS.
		BPRegister name: #B address: USER_MEMORY_ADDRESS + 1.
		BPRegister name: #C address: USER_MEMORY_ADDRESS + 2.
		BPRegister name: #D address: USER_MEMORY_ADDRESS + 3.
		BPRegister name: #SP address: USER_MEMORY_ADDRESS + 4.
		BPRegister name: #CARRY address: USER_MEMORY_ADDRESS + 5.
		BPRegister name: #ZERO address: USER_MEMORY_ADDRESS + 6.
		BPRegister name: #RETURN_SP address: USER_MEMORY_ADDRESS + 7.
		BPReservedMemoryZone name: #JUMP_IF_ZERO startAddress: USER_MEMORY_ADDRESS + 8 size: INSTRUCTION_SIZE.
		BPReservedMemoryZone name: #JUMP_IF_NONZERO startAddress: USER_MEMORY_ADDRESS + 8 + INSTRUCTION_SIZE size: INSTRUCTION_SIZE.
		BPReservedMemoryZone name: #INFINITE_NOP startAddress: USER_MEMORY_ADDRESS + 8 + (2 * INSTRUCTION_SIZE) size: INSTRUCTION_SIZE.
		BPReservedMemoryZone name: #DISPLAY_FRAME startAddress: 16r60000 size: PIXELS_COUNT.
		BPReservedMemoryZone name: #AUDIO_SAMPLE startAddress: 16r70000 size: AUDIO_SAMPLE_SIZE.
		BPAddPageBuilder reservedMemoryZoneStartingAt: 16r10000.
		BPAddZeroFlagPageBuilder reservedMemoryZoneStartingAt: 16r20000.
		BPAddCarryFlagPageBuilder reservedMemoryZoneStartingAt: 16r50000.
		BPCmpPageBuilder reservedMemoryZoneStartingAt: 16r30000.
		BPIdentityPageBuilder reservedMemoryZoneStartingAt: 16r40000.
		BPBitAndPageBuilder reservedMemoryZoneStartingAt: 16r80000.
		BPIncrementPageBuilder reservedMemoryZoneStartingAt: 16r41000.
		BPDecrementPageBuilder reservedMemoryZoneStartingAt: 16r42000.
		BPReservedMemoryZone name: #DATA_STACK startAddress: 16r40300 size: 16rFF.
		BPReservedMemoryZone name: #RETURN_STACK startAddress: 16r40400 size: 16rFF };
	yourself
]

{ #category : #adding }
BPMemoryLayout >> add: aLayoutObject [
	self ensureLayoutObjectDoesNotCreateConflict: aLayoutObject.
	layoutObjects add: aLayoutObject
]

{ #category : #adding }
BPMemoryLayout >> addAll: aCollectionOfLayoutObjects [
	aCollectionOfLayoutObjects do: [ :layoutObject |
		self add: layoutObject ]
]

{ #category : #accessing }
BPMemoryLayout >> endAddress [
	"The end address is the maximal address specified by BytePusher specifications."
	^ MAX_ADDRESS asBPAddress
]

{ #category : #private }
BPMemoryLayout >> ensureLayoutObjectDoesNotCreateConflict: aLayoutObject [
	self layoutObjects detect: [ :layoutObject |
		(aLayoutObject startAddress between: layoutObject startAddress and: layoutObject endAddress)
			or: [ (aLayoutObject endAddress between: layoutObject startAddress and: layoutObject endAddress) ] ]
		ifFound: [ :overlapingWith |
			self error: 'The layout object ',aLayoutObject name,' overlaps with an existing layout object ', overlapingWith name ].
		
	
]

{ #category : #extracting }
BPMemoryLayout >> extractDataStack: memory [
	^ (((self reservedMemoryZoneNamed: #DATA_STACK) access: memory)
			copyFrom: 1 to: ((self registerNamed: #SP) valueIn: memory)) reversed as: Stack
]

{ #category : #extracting }
BPMemoryLayout >> extractReturnStack: memory [
	"Returns a high-level object (instance of Stack) representing the return stack.
	 Instead of storing bytes of the address, instances of BPAddress are created to make
	 the content of the stack easier to understand.
	"
	^ ((((self reservedMemoryZoneNamed: #RETURN_STACK) access: memory)
			copyFrom: 1 to: ((self registerNamed: #RETURN_SP) valueIn: memory)) reversed groupsOf: 3 atATimeCollect: [ :low :middle :high |
				BPAddress lowByte: low middleByte: middle highByte: high ]) as: Stack
]

{ #category : #accessing }
BPMemoryLayout >> firstGenerationAddress [
	self layoutObjects overlappingPairsDo: [ :layoutObjectBefore :layoutObjectAfter |
		(layoutObjectBefore endAddress + 1 = layoutObjectAfter startAddress)
			ifFalse: [ ^ layoutObjectBefore endAddress + 1 ] ].
	self error: 'Invalid layout.'
]

{ #category : #initialization }
BPMemoryLayout >> initialize [
	super initialize.
	self layoutObjects: (SortedCollection sortBlock: [ :x :y | x startAddress < y startAddress ]).
]

{ #category : #'initialize memory' }
BPMemoryLayout >> initializeOpcodeBankMemoryZonesOn: aByteArray [
	self layoutObjects
		select: [ :layoutObject | 
			layoutObject isReservedMemoryZone and: [ layoutObject isForOpcodeBank ] ]
		thenDo: [ :opcodeBankReservedMemoryZone |
			opcodeBankReservedMemoryZone writeBankOn: aByteArray ]
]

{ #category : #accessing }
BPMemoryLayout >> layoutObjects [
	^ layoutObjects
]

{ #category : #accessing }
BPMemoryLayout >> layoutObjects: anObject [
	layoutObjects := anObject
]

{ #category : #accessing }
BPMemoryLayout >> registerNamed: aSymbol [
	^ self layoutObjects detect: [ :layoutObject |
		layoutObject isRegister and: [ layoutObject name = aSymbol ] ]
]

{ #category : #accessing }
BPMemoryLayout >> registers [
	^ self layoutObjects select: #isRegister
]

{ #category : #accessing }
BPMemoryLayout >> reservedMemoryZoneNamed: aSymbol [
	^ self layoutObjects detect: [ :layoutObject |
		layoutObject isReservedMemoryZone and: [ layoutObject name = aSymbol ] ]
]

{ #category : #accessing }
BPMemoryLayout >> startAddress [
	"Beginning of BytePusher memory, address is 0."
	^ 0 asBPAddress
]

{ #category : #accessing }
BPMemoryLayout >> typeName [
	^ 'Memory'
]
