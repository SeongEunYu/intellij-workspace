package kr.co.argonet.r2rims.google;

import java.util.*;

public class MemoryTable extends Table {
	public MemoryTable(String name, String[] keys) {
		super(name, keys);
	}

	protected class MemoryRecord extends Record {
		String[] values;

		MemoryRecord() {
			values = new String[getTable().getKeys().length];
		}

		@Override
		public Table getTable() {
			return MemoryTable.this;
		}

		@Override
		public String getValue(int index) {
			String value = values[index];

			return value == null ? "" : value;
		}

		@Override
		public void setValue(int index, String value) {
			values[index] = value;
		}
	};

	List<Record> records = new ArrayList<Record>();

	@Override
	public int getSize() {
		return records.size();
	}

	@Override
	public Record createRecord() {
		return new MemoryRecord();
	}

	@Override
	public void addRecord(Record record) {
		if (!(record instanceof MemoryRecord) || record.getTable() != this)
			throw new IllegalArgumentException(
					"You cannot add an incompatible record to memory table");

		records.add(record);
	}

	@Override
	public void deleteRecord(Record record) {
		records.remove(record);
	}

	@Override
	public Iterator<Record> iterator() {
		return records.iterator();
	}

	@Override
	public List<Record> findRecords(Map<String, String> pattern) {
		List<Record> result = new ArrayList<Record>();

		for (Record record : records) {
			if (record.matches(pattern))
				result.add(record);
		}

		return result;
	}

	public void print() {
		System.out.println("TABLE " + name);
		for (Record record : records)
			System.out.println(record);
	}

	@Override
	public int getIndex(String key) {
		for (int i = 0; i < keys.length; ++i)
			if (key.equals(keys[i]))
				return i;

		throw new IllegalArgumentException("Unknown key " + key);
	}
}
