Class {
	#name : #BPIncrementPageBuilder,
	#superclass : #BPOpcodeBankBuilder,
	#category : #'BytePusher-Assembler-Memory'
}

{ #category : #accessing }
BPIncrementPageBuilder class >> bankSize [
	^ 16rFF
]

{ #category : #accessing }
BPIncrementPageBuilder class >> reservedMemoryZone [
	^ super reservedMemoryZone
		name: #INCREMENT_PAGE;
		yourself
]

{ #category : #accessing }
BPIncrementPageBuilder class >> startAddress [
	^ 16r90000 asBPAddress
]

{ #category : #writing }
BPIncrementPageBuilder >> writeBankOn: aByteArray [
	self addressesRange do: [ :address | 
		|x|
		x := (address & 16rFF) + 1 % 16r100.
		aByteArray
			at: address + 1 "In byte pusher, addressing starts at 0, in Pharo it starts at 1."
			put: x ]
]
