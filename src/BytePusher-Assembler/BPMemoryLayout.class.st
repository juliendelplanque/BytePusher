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
		BPIdentityPageBuilder reservedMemoryZone };
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
	^ (MEMORY_SIZE - 1) asBPAddress
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
	|lastAddress|
	lastAddress := -1.
	^ (self layoutObjects detect: [ :layoutObject |
		(layoutObject startAddress memoryAddress ~= (lastAddress + 1))
			ifFalse: [ lastAddress := layoutObject endAddress memoryAddress. false ]
			ifTrue: [ true ] ]) endAddress + 1
]

{ #category : #'gt-inspector-extension' }
BPMemoryLayout >> gtInspectorItemsIn: composite [
	<gtInspectorPresentationOrder: 0> 
	^ (composite fastTable)
		title: 'Layout';
		display: [ self layoutObjects ];
		column: 'Name' 
			evaluated: [:each | GTObjectPrinter asTruncatedTextFrom: each name ];
		column: 'Type'
			evaluated: [ :each | each typeName ];
		column: 'Start address' 
			evaluated: [:each | each startAddress hex ] width: 80;
		column: 'End address' 
			evaluated: [:each | each endAddress hex ] width: 80;
		beSingle;
		yourself
]

{ #category : #initialization }
BPMemoryLayout >> initialize [
	super initialize.
	self layoutObjects: (SortedCollection sortBlock: [ :x :y | x startAddress < y startAddress ]).
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
