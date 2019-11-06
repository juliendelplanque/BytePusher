"
A BPAddressTest is a test class for testing the behavior of BPAddress
"
Class {
	#name : #BPAddressTest,
	#superclass : #TestCase,
	#category : #'BytePusher-Assembler-Tests-Model'
}

{ #category : #test }
BPAddressTest >> testAccess [
	| identityMemory |
	identityMemory := #[0 1 2 3].
	
	0 to: 3 do: [ :i |
		self assert: (i asBPAddress access: identityMemory) equals: i ]
]

{ #category : #test }
BPAddressTest >> testAccess2 [
	| reversedIdentityMemory |
	reversedIdentityMemory := #[3 2 1 0].
	
	0 to: 3 do: [ :i |
		self assert: (i asBPAddress access: reversedIdentityMemory) equals: 3 - i ]
]

{ #category : #test }
BPAddressTest >> testAccessInteger [
	| memory |
	memory := #[16r01 16r20 16r33 16r04 16r50].
	
	self assert: (0 asBPAddress accessInteger: memory) equals: 16r012033.
	self assert: (1 asBPAddress accessInteger: memory) equals: 16r203304.
	self assert: (2 asBPAddress accessInteger: memory) equals: 16r330450
]

{ #category : #test }
BPAddressTest >> testAsBPAddress [
	self assert: (BPAddress memoryAddress: 1234) equals: 1234 asBPAddress
]

{ #category : #test }
BPAddressTest >> testAsDataAccess [
	| address access |
	address := 123 asBPAddress.
	
	access := address asDataAccess.
	
	self assert: access class equals: BPAddressDataAccess.
	self assert: access address equals: address.
	self assert: access byteIndex equals: 0
]

{ #category : #test }
BPAddressTest >> testAsDataReference [
	| address access |
	address := 123 asBPAddress.
	
	access := address asDataReference.
	
	self assert: access class equals: BPAddressDataReference.
	self assert: access address equals: address.
	self assert: access byteIndex equals: 0
]

{ #category : #test }
BPAddressTest >> testByteAt [
	| address |
	address := 16r040506 asBPAddress.
	
	self assert: (address byteAt: 0) equals: 16r04.
	self assert: (address byteAt: 1) equals: 16r05.
	self assert: (address byteAt: 2) equals: 16r06.
]

{ #category : #test }
BPAddressTest >> testHex [
	| address |
	address := 16r040506 asBPAddress.
	self assert: address hex equals: '040506'.
	
	address := 16r000001 asBPAddress.
	self assert: address hex equals: '000001'
]

{ #category : #test }
BPAddressTest >> testHigherByte [
	| address |
	address := 16r040506 asBPAddress.
	
	self assert: address higherByte equals: 16r04
]

{ #category : #test }
BPAddressTest >> testLowerByte [
	| address |
	address := 16r040506 asBPAddress.
	
	self assert: address lowerByte equals: 16r06
]

{ #category : #test }
BPAddressTest >> testMiddleByte [
	| address |
	address := 16r040506 asBPAddress.
	
	self assert: address middleByte equals: 16r05
]

{ #category : #test }
BPAddressTest >> testStoreAddressIn [

	self flag: #toImplement.
	self assert: false
]

{ #category : #test }
BPAddressTest >> testStoreIn [

	self flag: #toImplement.
	self assert: false
]

{ #category : #test }
BPAddressTest >> testStoreIntegerIn [

	self flag: #toImplement.
	self assert: false
]

{ #category : #test }
BPAddressTest >> testWriteOnAt [

	self flag: #toImplement.
	self assert: false
]
