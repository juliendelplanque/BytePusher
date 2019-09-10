Class {
	#name : #BPMemoryLayout,
	#superclass : #BPLayoutObject,
	#instVars : [
		'layoutObjects'
	],
	#pools : [
		'BPConstants'
	],
	#category : #'BytePusher-Assembly'
}

{ #category : #factory }
BPMemoryLayout class >> standard [
	^ self new
		addAll: {
		BPReservedMemoryZone name: #KEYBOARD_STATE startAddress: KEYBOARD_STATE_ADDRESS size: 2.
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
		BPReservedMemoryZone name: #JUMP_IF_ZERO startAddress: USER_MEMORY_ADDRESS + 7 size: INSTRUCTION_SIZE.
		BPReservedMemoryZone name: #JUMP_IF_NONZERO startAddress: USER_MEMORY_ADDRESS + 7 + INSTRUCTION_SIZE size: INSTRUCTION_SIZE.
		BPReservedMemoryZone name: #DISPLAY_FRAME startAddress: 16rFE0000 size: PIXELS_COUNT.
		BPReservedMemoryZone name: #AUDIO_SAMPLE startAddress: USER_MEMORY_ADDRESS + 7 + (2 * INSTRUCTION_SIZE) + PIXELS_COUNT size: AUDIO_SAMPLE_SIZE.
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
	^ MEMORY_SIZE - 1
]

{ #category : #private }
BPMemoryLayout >> ensureLayoutObjectDoesNotCreateConflict: aLayoutObject [
	self layoutObjects detect: [ :layoutObject |
		(aLayoutObject startAddress between: layoutObject startAddress and: layoutObject endAddress)
			or: [ (aLayoutObject endAddress between: layoutObject startAddress and: layoutObject endAddress) ] ]
		ifFound: [ :overlapingWith |
			self error: 'The layout object ',aLayoutObject name,' overlaps with an existing layout object ', overlapingWith name ].
		
	
]

{ #category : #initialization }
BPMemoryLayout >> initialize [
	super initialize.
	self layoutObjects: OrderedCollection new.
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
	^ self shouldBeImplemented
]

{ #category : #accessing }
BPMemoryLayout >> reservedMemoryZoneNamed: aSymbol [
	^ self shouldBeImplemented
]

{ #category : #accessing }
BPMemoryLayout >> startAddress [
	"Beginning of BytePusher memory, address is 0."
	^ 0
]
