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
		BPReservedMemoryZone name: #RESERVED_BLANK startAddress: USER_MEMORY_ADDRESS + 7 size: 1.
		BPReservedMemoryZone name: #JUMP_IF_ZERO startAddress: USER_MEMORY_ADDRESS + 8 size: INSTRUCTION_SIZE.
		BPReservedMemoryZone name: #JUMP_IF_NONZERO startAddress: USER_MEMORY_ADDRESS + 8 + INSTRUCTION_SIZE size: INSTRUCTION_SIZE.
		BPReservedMemoryZone name: #INFINITE_NOP startAddress: USER_MEMORY_ADDRESS + 8 + (2 * INSTRUCTION_SIZE) size: INSTRUCTION_SIZE.
		BPReservedMemoryZone name: #DISPLAY_FRAME startAddress: 16r60000 size: PIXELS_COUNT.
		BPReservedMemoryZone name: #AUDIO_SAMPLE startAddress: 16r70000 size: AUDIO_SAMPLE_SIZE.
		BPAddPageBuilder reservedMemoryZone.
		BPAddZeroFlagPageBuilder reservedMemoryZone.
		BPAddCarryFlagPageBuilder reservedMemoryZone.
		BPCmpPageBuilder reservedMemoryZone.
		BPIdentityPageBuilder reservedMemoryZone.
		BPBitAndPageBuilder reservedMemoryZone.
		BPIncrementPageBuilder reservedMemoryZone };
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
