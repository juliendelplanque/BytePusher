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
BPAddressTest >> testAsAddressReference [
	| address access |
	address := 123 asBPAddress.
	access := address asAddressReference.
	self assert: access class equals: BPAddressReference.
	self assert: access objectWithAddress equals: address.
	self assert: access offset equals: 0
]

{ #category : #test }
BPAddressTest >> testAsBPAddress [
	self assert: (BPAddress memoryAddress: 1234) equals: 1234 asBPAddress
]

{ #category : #test }
BPAddressTest >> testAsDataReference [
	| address access |
	address := 123 asBPAddress.
	
	access := address asDataReference.
	
	self assert: access class equals: BPAddressDataReference.
	self assert: access objectWithAddress equals: address.
	self assert: access offset equals: 0
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
BPAddressTest >> testSetHigherByte [
	| address |
	address := 16r040506 asBPAddress.
	
	address higherByte: 16r07.
	
	self assert: address higherByte equals: 16r07.
	self assert: address memoryAddress equals: 16r070506
]

{ #category : #test }
BPAddressTest >> testSetLowerByte [
	| address |
	address := 16r040506 asBPAddress.
	
	address lowerByte: 16r07.
	
	self assert: address lowerByte equals: 16r07.
	self assert: address memoryAddress equals: 16r040507
]

{ #category : #test }
BPAddressTest >> testSetMiddleByte [
	| address |
	address := 16r040506 asBPAddress.
	
	address middleByte: 16r07.
	
	self assert: address middleByte equals: 16r07.
	self assert: address memoryAddress equals: 16r040706
]

{ #category : #test }
BPAddressTest >> testStoreAddressIn [
	| memory |
	memory := #[0 0 0 0 0] shallowCopy.
	16r0 asBPAddress storeAddress: 16r00ABCD asBPAddress in: memory.
	self assert: memory equals: #[16r00 16rAB 16rCD 0 0].
	
	16r2 asBPAddress storeAddress: 16r00ABCD asBPAddress in: memory.
	self assert: memory equals: #[16r00 16rAB 16r00 16rAB 16rCD ].
	
	self should: [ 16r4 asBPAddress storeAddress: 16r00ABCD asBPAddress in: memory ] raise: SubscriptOutOfBounds
]

{ #category : #test }
BPAddressTest >> testStoreIn [
	| memory |
	memory := #[0 0 0 0 0] shallowCopy.
	16r0 asBPAddress store: 1 in: memory.
	self assert: memory equals: #[1 0 0 0 0].
	
	16r4 asBPAddress store: 2 in: memory.
	
	self assert: memory equals: #[1 0 0 0 2].
	
	self
		should: [ 16r5 asBPAddress store: 2 in: memory ]
		raise: SubscriptOutOfBounds
		withExceptionDo: [ :error |
			self assert: error subscript equals: 16r5.
			self assert: error lowerBound equals: 0.
			self assert: error upperBound equals: 4.
			self assert: error signaler equals: memory ]
]

{ #category : #test }
BPAddressTest >> testStoreIntegerIn [
	| memory |
	memory := #[0 0 0 0 0] shallowCopy.
	16r0 asBPAddress storeInteger: 16rABCDEF in: memory.
	self assert: memory equals: #[16rAB 16rCD 16rEF 0 0].
	
	16r2 asBPAddress storeInteger: 16rABCDEF in: memory.
	self assert: memory equals: #[16rAB 16rCD 16rAB 16rCD 16rEF].
	
	self should: [ 16r4 asBPAddress storeInteger: 16rABCDEF in: memory ] raise: SubscriptOutOfBounds
]
