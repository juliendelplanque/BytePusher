Class {
	#name : #BPAddressDataReference,
	#superclass : #BPReferenceToEntityWithAddress,
	#category : #'BytePusher-Assembler-Model'
}

{ #category : #'instance creation' }
BPAddressDataReference class >> address: address byteIndex: byteIndex [
	^ self new
		address: address;
		offset: byteIndex;
		yourself
]

{ #category : #visiting }
BPAddressDataReference >> acceptVisitor: aBPAssemblerVisitor [
	<generated>
	^ aBPAssemblerVisitor visitBPAddressDataReference: self
]

{ #category : #accessing }
BPAddressDataReference >> address [
	^ self objectWithAddress address
]
