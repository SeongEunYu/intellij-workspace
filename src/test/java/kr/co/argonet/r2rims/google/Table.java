package kr.co.argonet.r2rims.google;

import java.util.*;

/**
 * A simple database table interface which can be easily backed by memory or
 * some fancy database.
 */
public abstract class Table implements Iterable<Record> {
	protected Table(String name, String[] keys) {
		this.name = name;
		this.keys = keys;
	}

	protected String name;

	/**
	 * Returns the name of the table.
	 */
	public String getName() {
		return name;
	}

	protected String[] keys;

	/**
	 * Returns the set of all keys (columns) of this table.
	 */
	public String[] getKeys() {
		return keys;
	}

	/**
	 * Returns the index of the given key in the keys array.
	 */
	public int getIndex(String key) {
		for (int i = 0; i < keys.length; ++i)
			if (keys[i].equals(key))
				return i;

		throw new IllegalArgumentException("Table does not have this key: "+ key);
	}

	/**
	 * Returns <code>true</code> if the table contains values for the given key.
	 */
	public boolean hasKey(String key) {
		for (int i = 0; i < keys.length; ++i)
			if (keys[i].equals(key))
				return true;

		return false;
	}

	/**
	 * Returns <code>true</code>, if all the keys are present in this table.
	 */
	public boolean hasKeys(String[] keys) {
		for (String key : keys)
			if (!hasKey(key))
				return false;

		return true;
	}

	/**
	 * Returns the number of records in the table
	 */
	abstract public int getSize();

	/**
	 * Creates an empty record. You still need to add this record to the table
	 * to make it persistent.
	 */
	public abstract Record createRecord();

	/**
	 * Adds the specified record to the database. Multiple records can coexists,
	 * and the database can modify (add index values to) the record.
	 */
	public abstract void addRecord(Record record);

	/**
	 * Removes this record from the database. This record must have been
	 * obtained from this database.
	 */
	public abstract void deleteRecord(Record record);

	/**
	 * Returns an iterator that traverses all records of this table.
	 */
	@Override
	public abstract Iterator<Record> iterator();

	/**
	 * Finds all records in the database that matches the given pattern. All
	 * fields of the pattern must match exactly.
	 */
	public abstract List<Record> findRecords(Map<String, String> pattern);

	/**
	 * Short hand for finding all records that have the given value at the given
	 * key.
	 */
	public List<Record> findRecords(String key, String value) {
		Map<String, String> pattern = new HashMap<String, String>();
		pattern.put(key, value);

		return findRecords(pattern);
	}
}
