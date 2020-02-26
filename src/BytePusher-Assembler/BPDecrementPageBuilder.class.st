Class {
	#name : #BPDecrementPageBuilder,
	#superclass : #BPOpcodeBankBuilder,
	#category : #'BytePusher-Assembler-Memory'
}

{ #category : #accessing }
BPDecrementPageBuilder class >> bankSize [
	^ 16rFF
]

{ #category : #accessing }
BPDecrementPageBuilder class >> reservedMemoryZone [
	^ super reservedMemoryZone
		name: #DECREMENT_PAGE;
		yourself
]

{ #category : #accessing }
BPDecrementPageBuilder class >> startAddress [
	^ 16r40200 asBPAddress
]

{ #category : #writing }
BPDecrementPageBuilder >> writeBankOn: aByteArray [
	self addressesRange do: [ :address | 
		|x|
		x := (address & 16rFF) - 1 % 16r100.
		aByteArray
			at: address + 1 "In byte pusher, addressing starts at 0, in Pharo it starts at 1."
			put: x ]
]
