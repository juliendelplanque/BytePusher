"
I model the whole layout of a virtual machine memory.
I am a composite object containing registers and reserved memory zones.
My purpose is to describe to the assembler how the memory is organized allowing it to know how to generate the bytecode.

My #startAddress and #endAddress are defined by the virtual machine specifications.

I provide a nice API to manipulate my registers and reserved memory zones.

I also ensure that the memory layout built by my client is consistent (none of my layout objects overlap in the memory).

Check my subclasses for concrete memory layouts.
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
	"The end address is the maximal address addressable by the virtual machine."
	^ self subclassResponsibility
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
	^ (self layoutObjects detectMax: #endAddress) endAddress + 1
]

{ #category : #initialization }
BPMemoryLayout >> initialize [
	super initialize.
	self layoutObjects: (SortedCollection sortBlock: [ :x :y | x startAddress < y startAddress ]).
]

{ #category : #'initialize memory' }
BPMemoryLayout >> initializeMemory: aByteArray [
	"Initialize memory of opcode banks."
	self
		initializeOpcodeBankMemoryZonesOn: aByteArray
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
	"Beginning of virtual machine memory."
	^ 0 asBPAddress
]

{ #category : #accessing }
BPMemoryLayout >> typeName [
	^ 'Memory'
]
